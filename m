Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaESLkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:40:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21345 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaESLkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:40:23 -0400
Date: Mon, 19 May 2014 14:40:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Karim Raslan <karim.allah.ahmed@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au: rtw_sta_mgt: change
 rtw_alloc_stainfo23a to use gfp_t instead if int
Message-ID: <20140519114000.GW15585@mwanda>
References: <1400395256-8892-1-git-send-email-karim.allah.ahmed@gmail.com>
 <20140519101855.GU15585@mwanda>
 <wrfjtx8mrrp2.fsf@ultrasam.lan.trained-monkey.org>
 <20140519104012.GP16255@mwanda>
 <wrfjlhtyrqlc.fsf@ultrasam.lan.trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wrfjlhtyrqlc.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:49:03PM +0200, Jes Sorensen wrote:
> You should be running your tools against the staging tree automatically,
> that way you catch it before it hits the mainline tree.
>
> Just flooding mailing lists for the sake of flooding them doesn't add
> any value either.

We are used to handling the traffic.  Heh.  Don't worry about us.  ;)

I don't actually run static analysis on staging patches until they hit
linux-next, I only review the mailing list patches manually.  My review
process is built around mailing lists so creating a special process for
rtl8723au makes my life harder instead of easier.  Every subsystem has a
review process, it's not that we are treating you unfairly by asking you
to send your patches for review.

Btw, Greg doesn't rebase the staging tree so, once a patch is merged,
then it means it will hit mainline.  At that point, it is too late to
send a second version of the patch.

You should be running Sparse yourself as part of your own QC tests
before submitting patches to review.  http://lwn.net/Articles/205624/
It is a normal minimum requirement along with checkpatch.pl.

regards,
dan carpenter

