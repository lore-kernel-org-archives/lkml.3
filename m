Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3LEI5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:57:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19621 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3LEI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:57:47 -0500
Date: Thu, 5 Dec 2013 11:57:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gary Rookard <garyrookard@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        lisa@xenapiadmin.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: bcm: DDRInit: Fixed coding style issue,
 replaced spaces w/ tabs.(patch set)
Message-ID: <20131205085736.GY28413@mwanda>
References: <1386203179-21041-1-git-send-email-garyrookard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386203179-21041-1-git-send-email-garyrookard@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These five patches all do the same thing.  It's ok to merge them into
one patch.

The subject lines are all the same and that's not ok.  The subject lines
are too long as well.

On Wed, Dec 04, 2013 at 07:26:19PM -0500, Gary Rookard wrote:
> This is the first patch of a series.

Don't put this in the description.

> Replaced spaces in margin w/ 1 tab for lines:
>  11-15, 17-23, 25-58, 60, 62, 64
> 

No signed off by line.

>  On branch staging-next

Put this between the --- and the diffstat.
> ---

<-- here.

>  drivers/staging/bcm/DDRInit.c | 98 +++++++++++++++++++++----------------------
>  1 file changed, 49 insertions(+), 49 deletions(-)

regards,
dan carpenter
