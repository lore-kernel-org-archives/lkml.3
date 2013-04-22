Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3DVBNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 21:13:07 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59844 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3DVBNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 21:13:06 -0400
Date: Sun, 21 Apr 2013 18:13:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
Message-ID: <20130422011303.GA15095@kroah.com>
References: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
 <20130419232419.GA8900@kroah.com>
 <d4d63db63a53466bb568363bb4c30054@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4d63db63a53466bb568363bb4c30054@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 10:32:45PM +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, April 19, 2013 7:24 PM
> > To: Olaf Hering
> > Cc: KY Srinivasan; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
> > 
> > On Tue, Mar 26, 2013 at 04:28:27PM +0100, Olaf Hering wrote:
> > > This change fixes a few compile errors:
> > >
> > > hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> > > hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> > > hv_vss_daemon.c: In function 'vss_operate':
> > > hv_vss_daemon.c:66: warning: 'return' with no value, in function returning
> > non-void
> > > hv_vss_daemon.c: In function 'main':
> > > hv_vss_daemon.c:130: warning: ignoring return value of 'daemon', declared
> > with attribute warn_unused_result
> > > hv_vss_daemon.c: In function 'vss_operate':
> > > hv_vss_daemon.c:47: warning: 'fs_op' may be used uninitialized in this function
> > >
> > > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> > 
> > For some reason, all of your hv tools patches ended up in my spam
> > filter.  KY, can you resend me any that I didn't apply, and you have
> > tested?
> 
> Greg,
> 
> I forwarded some patches from Olaf (I think Olaf is on vacation) that
> have not been applied. I had acked all these patches when Olaf sent
> them out initially.

Can you please resend them in a format that I can apply them in (hint,
I should never have to edit the patch by hand from you.)

thanks,

greg k-h
