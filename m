Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbbAGEq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 23:46:56 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52365 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbbAGEqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 23:46:54 -0500
Date: Wed, 7 Jan 2015 10:16:42 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: vt8500lcdfb: remove unneeded continue
Message-ID: <20150107044642.GA2543@sudip-PC>
References: <1420548302-11489-1-git-send-email-sudipm.mukherjee@gmail.com>
 <54AC2A0B.3040807@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AC2A0B.3040807@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 09:31:39PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 01/06/2015 03:45 PM, Sudip Mukherjee wrote:
> 
> >continue is not needed at the end of a for loop
> 
> >Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> >---
> >  drivers/video/fbdev/vt8500lcdfb.c | 1 -
> >  1 file changed, 1 deletion(-)
> 
> >diff --git a/drivers/video/fbdev/vt8500lcdfb.c b/drivers/video/fbdev/vt8500lcdfb.c
> >index ffaf29e..6716bf5 100644
> >--- a/drivers/video/fbdev/vt8500lcdfb.c
> >+++ b/drivers/video/fbdev/vt8500lcdfb.c
> >@@ -115,7 +115,6 @@ static int vt8500lcd_set_par(struct fb_info *info)
> >  	for (i = 0; i < 8; i++) {
> >  		if (bpp_values[i] == info->var.bits_per_pixel) {
> >  			reg_bpp = i;
> >-			continue;
> >  		}
> 
>    {} are not needed any more either. ;-)

i have noticed that but thought that will be again a different type of change in a single patch.
but now it seems that this patch will introduce a new checkpatch warning, so i should have corrected that in it.
i will send a v2.

thanks
sudip

> 
> [...]
> 
> WBR, Sergei
> 
