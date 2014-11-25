Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaKYMRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:17:31 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47372 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaKYMR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:17:29 -0500
Date: Tue, 25 Nov 2014 15:17:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Athira Lekshmi C V <andnlnbn18@gmail.com>
Cc: gregkh@linuxfoundation.org, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:staging:vt6656: Fixed checkpatch warning
Message-ID: <20141125121713.GC4835@mwanda>
References: <1416917740-5001-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416917740-5001-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 05:45:40PM +0530, Athira Lekshmi C V wrote:
> Fixed the checkpatch warning:
> WARNING: Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)

For these changes the change log must say how you determined both
source and destination are aligned correctly.

regards,
dan carpenter

