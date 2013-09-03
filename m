Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581Ab3ICVql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759364Ab3ICVqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:46:40 -0400
Date: Tue, 3 Sep 2013 17:46:26 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        john453@faraday-tech.com
Subject: Re: usb: host: Faraday fotg210-hcd driver
Message-ID: <20130903214626.GA10542@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	john453@faraday-tech.com
References: <20130903185912.A59316601F4@gitolite.kernel.org>
 <20130903211544.GB2247@redhat.com>
 <20130903212355.GA12978@kroah.com>
 <20130903213205.GA7433@redhat.com>
 <20130903214009.GA16463@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903214009.GA16463@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 02:40:09PM -0700, Greg KH wrote:
 > On Tue, Sep 03, 2013 at 05:32:05PM -0400, Dave Jones wrote:
 
 > > PS: What happened with this driver ?
 > > 
 > > This patch landed twice in your tree, once in 1dd3d123239179fad5de5dc00a6e0014a1918fde from Yuan-Hsin Chen <yhchen@faraday-tech.com>
 > > and then in 7d50195f6c5005d6ae7a789d9a7f0a94d104ee96 from Feng-Hsin Chiang <john453@faraday-tech.com>
 > > 
 > > Given the former address seems to be broken, perhaps all those mentions of it
 > > in the faraday sources need updating ?
 > 
 > I thought they had all been fixed up.  The first version was dropped
 > because the maintainer no longer worked for the company (as you found
 > out), so I needed a new developer to step up and support it.

He's still mentioned in a bunch of MODULE_AUTHOR's.
While it seems sort of rude to delete mention of someones work, having a dead email
address seems bad form too. Perhaps the patch below ?

	Dave

Update the MODULE_AUTHOR field of the Faraday OTG drivers to reflect
current maintainers email address.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/usb/gadget/fotg210-udc.c b/drivers/usb/gadget/fotg210-udc.c
index 32db2ee..bbbfd19 100644
--- a/drivers/usb/gadget/fotg210-udc.c
+++ b/drivers/usb/gadget/fotg210-udc.c
@@ -1214,6 +1214,6 @@ static struct platform_driver fotg210_driver = {
 
 module_platform_driver(fotg210_driver);
 
-MODULE_AUTHOR("Yuan-Hsin Chen <yhchen@faraday-tech.com>");
+MODULE_AUTHOR("Yuan-Hsin Chen, Feng-Hsin Chiang <john453@faraday-tech.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index f1dd6da..b278abe 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -22,7 +22,7 @@
 
 MODULE_DESCRIPTION("FUSB300  USB gadget driver");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Yuan Hsin Chen <yhchen@faraday-tech.com>");
+MODULE_AUTHOR("Yuan-Hsin Chen, Feng-Hsin Chiang <john453@faraday-tech.com>");
 MODULE_ALIAS("platform:fusb300_udc");
 
 #define DRIVER_VERSION	"20 October 2010"
