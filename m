Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaESKTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:19:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22848 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaESKTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:19:17 -0400
Date: Mon, 19 May 2014 13:18:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Karim Raslan <karim.allah.ahmed@gmail.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au: rtw_sta_mgt: change
 rtw_alloc_stainfo23a to use gfp_t instead if int
Message-ID: <20140519101855.GU15585@mwanda>
References: <1400395256-8892-1-git-send-email-karim.allah.ahmed@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400395256-8892-1-git-send-email-karim.allah.ahmed@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 07:39:23AM +0100, Karim Raslan wrote:
> This should fix a few sparse warnings like the following:
> 
>   CHECK   drivers/staging/rtl8723au/core/rtw_ap.c
> drivers/staging/rtl8723au/core/rtw_ap.c:1054:45: warning: incorrect type in argument 3 (different base types)
> drivers/staging/rtl8723au/core/rtw_ap.c:1054:45:    expected int [signed] gfp
> drivers/staging/rtl8723au/core/rtw_ap.c:1054:45:    got restricted gfp_t
> 

Thanks, Karim, looks good.

Jes's patch which added this never went to the list so I didn't review
it.  This annoys me.

I try to be fair when I review code.  I try to allow lots of patches in
and let people send fix up patches for minor stuff.  But, obviously, you
should be running Sparse as part of the review process so if I made you
redo this patch it's because your process is broken.  When I review
patches I am trying to help you.

regards,
dan carpenter

