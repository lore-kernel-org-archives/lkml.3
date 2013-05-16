Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3EPDGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 23:06:36 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36520 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3EPDGd (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 15 May 2013 23:06:33 -0400
Message-ID: <1368673581.2272.5.camel@linux-04b7.site>
Subject: Re: [PATCH] Staging: add USB MTK bluetooth driver
From: AL Yu-Chen Cho <acho@suse.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        jay.hung@mediatek.com
Date: Thu, 16 May 2013 11:06:21 +0800
In-Reply-To: <20130514192748.GA16887@kroah.com>
References: <1367490436-8438-1-git-send-email-acho@suse.com>
	 <20130514192748.GA16887@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 二, 2013-05-14 at 15:27 -0400, Greg KH wrote:
> On Thu, May 02, 2013 at 06:27:16PM +0800, Cho, Yu-Chen wrote:
> > diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> > index fa41b04..e33cfe0 100644
> > --- a/drivers/staging/Makefile
> > +++ b/drivers/staging/Makefile
> > @@ -62,3 +62,4 @@ obj-$(CONFIG_SB105X)		+= sb105x/
> >  obj-$(CONFIG_GOLDFISH)		+= goldfish/
> >  obj-$(CONFIG_USB_DWC2)		+= dwc2/
> >  obj-$(CONFIG_LUSTRE_FS)		+= lustre/
> > +obj-$(CONFIG_USB_BTMTK)		+= btmkt_usb/
> 
> You didn't actually test this patch, it breaks the build:
> 
> scripts/Makefile.build:44:
> /home/gregkh/linux/work/staging/drivers/staging/btmkt_usb/Makefile: No such file or directory
> make[3]: *** No rule to make target
> `/home/gregkh/linux/work/staging/drivers/staging/btmkt_usb/Makefile'.  Stop.
> 
> Please refresh this against 3.10-rc1 and test that it builds properly
> and then resend it.
> 

Yes, I found that , and I will refresh this against 3.10-rc1 and test
that it builds then resend it soon.

Thanks a lot.

Sincerely,
         AL

