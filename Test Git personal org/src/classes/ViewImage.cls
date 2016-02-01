public class ViewImage {

      public Attachment att {

            get {

                  if (att == null) {

                        String id = ApexPages.currentPage().getParameters().get('AttachmentID');

                        att = [SELECT Body, ContentType, Name FROM Attachment WHERE ID = :id];

                  }

                  return att;

            }

            private set;

      }

      public String image {

            get {

                  return EncodingUtil.Base64Encode(att.body);

            }

      }

}