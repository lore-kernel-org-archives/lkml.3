Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbaLWPIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:08:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24422 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLWPIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:08:16 -0500
Date: Tue, 23 Dec 2014 18:08:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kroderia <kroderia@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: skein: Delete a useless white space line
Message-ID: <20141223150810.GC5021@mwanda>
References: <1419345473-6591-1-git-send-email-kroderia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419345473-6591-1-git-send-email-kroderia@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 02:37:53PM +0000, Kroderia wrote:
> Delete a useless white space line according to the coding style.
> 
> PS: I also found some one-line macros using do {} while (0) loop, 
> feel like they are useless should be delete.

Don't put this useless information in the permanent git log.

> 
> Signed-off-by: Kroderia <kroderia@gmail.com>

This doesn't seem like a legal name.

regards,
dan carpenter

