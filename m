Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaESJDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:03:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46516 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaESJDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:03:06 -0400
Date: Mon, 19 May 2014 12:02:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Saraev <antonysaraev@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, jason@lakedaemon.net, jake@lwn.net
Subject: Re: [PATCH v2 02/06] staging: crypto: skein: rename camelcase vars
Message-ID: <20140519090246.GQ15585@mwanda>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:09:55PM +0400, Anton Saraev wrote:
>  #if SKEIN_UNROLL_256 == 0
> -#define R256(p0, p1, p2, p3, ROT, rNum) /* fully unrolled */ \
> +#define R256(p0, p1, p2, p3, ROT, r_num) /* fully unrolled */ \
>  do { \
> -	Round256(p0, p1, p2, p3, ROT, rNum) \
> -	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr); \
> +	Round256(p0, p1, p2, p3, ROT, r_num); \
> +	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, r_num, X_ptr); \

Adding a semi-colon here looks suspiciously like a compile fix.  It's
great that you're fixing bugs, but do it in a separate patch with a
changelog.

regards,
dan carpenter

