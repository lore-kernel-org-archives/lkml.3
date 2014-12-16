Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaLPVDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:03:44 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:50498 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaLPVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:03:43 -0500
Date: Wed, 17 Dec 2014 08:03:10 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 8/9] virtio_pci: split out legacy device support
Message-ID: <20141216210309.GA32071@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418043812-25753-9-git-send-email-mst@redhat.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.virtualization
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin <mst@redhat.com> wrote:
> Move everything dealing with legacy devices out to virtio_pci_legacy.c.
> Expose common code APIs in virtio_pci.h
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

This breaks virtio_pci because you deleted the licence from it.

-- >8 --
Subject: virtio_pci: Restore module licence and other attributes

When the virtio_pci driver was moved into virtio_pci_legacy.c the
module licence and other attributes went AWOL.  This patch restores
them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 2588252..6b100e3 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -324,3 +324,8 @@ static struct pci_driver virtio_pci_driver = {
 };
 
 module_pci_driver(virtio_pci_driver);
+
+MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
+MODULE_DESCRIPTION("virtio-pci");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1");

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
