Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaESKkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:40:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30327 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaESKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:40:41 -0400
Date: Mon, 19 May 2014 13:40:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Karim Raslan <karim.allah.ahmed@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au: rtw_sta_mgt: change
 rtw_alloc_stainfo23a to use gfp_t instead if int
Message-ID: <20140519104012.GP16255@mwanda>
References: <1400395256-8892-1-git-send-email-karim.allah.ahmed@gmail.com>
 <20140519101855.GU15585@mwanda>
 <wrfjtx8mrrp2.fsf@ultrasam.lan.trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wrfjtx8mrrp2.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:25:13PM +0200, Jes Sorensen wrote:
> Dan,
> 
> Calm down, I haven't been bombarding the list, due to the sheer volume
> of commits.  If you want me to spam the list, tell me where and I'll add
> that to the CC list next time.

We provide the scripts/get_maintainer.pl script for that.  You can leave
linux-kernel off if you want because they don't care about staging
drivers.  The staging list is devel@driverdev.osuosl.org.

regards,
dan carpenter

