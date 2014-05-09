Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaEIH7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:59:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaEIH7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:59:21 -0400
Date: Fri, 9 May 2014 10:59:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        nandu.hgowda@gmail.com, sachin.kamat@linaro.org,
        peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
        himangi774@gmail.com, fempsci@gmail.com
Subject: Re: [PATCH 1/3] staging: cxt1e1: Fix no spaces at the start of a
 line in musycc.c
Message-ID: <20140509075904.GJ26890@mwanda>
References: <20140509013843.GA30927@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509013843.GA30927@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 10:38:43AM +0900, Daeseok Youn wrote:
> clean up checkpatch.pl warning:
>  WARNING: please no spaces at the start of a line in
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> This patch includes cleanup for fixing line length.
> 

This patch is super hard to review.  Your "line length" fixes include
moving variable declarations around, deleting comments, getting rid of
nonsense curly braces.  Those are all great but the patch is over a
thousand lines long and it's difficult to review.

If you just change spaces to tabs, that takes me 5 seconds to review
because I have scripts and email macros to do that.

If you just delete the #if 0 blocks that also is easy to review in a
single patch.

Just delete all the code that depends on #ifdef RLD_DUMP_BUFDATA because
that stuff is never set.

Please break this up into smaller patches and also write a better
changelog.

regards,
dan carpenter

