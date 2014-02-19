Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaBSIJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:09:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41770 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaBSIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:09:10 -0500
Date: Wed, 19 Feb 2014 11:08:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Staging: comedi: addi-data: cleanup comments in
 hwdrv_apci1564.c
Message-ID: <20140219080855.GR26722@mwanda>
References: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:36:46AM -0600, Chase Southwood wrote:
> hwdrv_apci1564.c had a lot of commented out conditional statements that
> were often identical to other un-commented out statements nearby, so it
> should be safe to just delete all of these commented out lines.  This
> patch also converts the remaining comments to the preferred kernel style
> for comments.
> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>

Reviewed-by:  Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

