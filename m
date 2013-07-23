Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab3GWJyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:54:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38342 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3GWJyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:54:24 -0400
Date: Tue, 23 Jul 2013 12:54:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lilis Iskandar <veeableful@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Qos: Fix some coding style issues
Message-ID: <20130723095416.GM5585@mwanda>
References: <1374571229.15906.3.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374571229.15906.3.camel@desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hi,

Welcome first time submitter newbie.  :)  The tradition is to reject
first time code submissions in the meanest and grumpiest way
possible.

On Tue, Jul 23, 2013 at 05:20:29PM +0800, Lilis Iskandar wrote:
> >From a2f8b299baee0e075d548d2bbf77619373035446 Mon Sep 17 00:00:00 2001
> From: Lilis Iskandar <veeableful@gmail.com>
> Date: Tue, 23 Jul 2013 17:08:37 +0800
> Subject: [PATCH] Staging: bcm: Qos: Fix some coding style issues

This header stuff is not needed.  See if you can figure out how to
get rid of it.

You are fixing too many kinds of problems at once so the patch is
impossible to review.  Please break it up into one kind of issue
per patch.

> -		if(FALSE == (bClassificationSucceed =
> +		if (FALSE == (bClassificationSucceed =
>  			MatchSrcPort(pstClassifierRule,
> -				ntohs((iphd->protocol == UDP)?
> -				xprt_hdr->uhdr.source:xprt_hdr->thdr.source))))
> +			ntohs((iphd->protocol == UDP)?
> +			xprt_hdr->uhdr.source : xprt_hdr->thdr.source))))
> +		{
>  			break;
> +		}

I don't know why you are adding curly braces here but they don't
belong.  Braces are explained in CodingStyle.

regards,
dan carpenter

