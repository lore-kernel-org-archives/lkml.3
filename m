Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaFPIRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:17:21 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29630 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaFPIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:17:19 -0400
Date: Mon, 16 Jun 2014 11:17:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Seunghun Lee <waydi1@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        alois.schloegl@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ced1401: fix sparse warning for ced1401
Message-ID: <20140616081718.GD5500@mwanda>
References: <1402722278-23040-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402722278-23040-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 02:04:38PM +0900, Seunghun Lee wrote:
> This patch fixes below warning.
> 
> drivers/staging/ced1401/ced_ioc.c:703:30: warning: incorrect type in assignment (different address spaces)
> 	drivers/staging/ced1401/ced_ioc.c:703:30:    expected void *[usertype] lpvBuff
> 	drivers/staging/ced1401/ced_ioc.c:703:30:    got char [noderef] <asn:1>*puBuf
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>

No.  This silences the warning by disabling Sparse.

Fix the annotations instead.

regards,
dan carpenter

