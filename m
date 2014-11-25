Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaKYN71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:59:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32741 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaKYN70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:59:26 -0500
Date: Tue, 25 Nov 2014 16:59:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Athira Lekshmi C V <andnlnbn18@gmail.com>
Cc: gregkh@linuxfoundation.org, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:Staging:vt6656: Fixed checkpatch warning
Message-ID: <20141125135906.GD4835@mwanda>
References: <1416922551-7401-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416922551-7401-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 07:05:51PM +0530, Athira Lekshmi C V wrote:
> Fixed the checkpatch warning:
> WARNING: else is not generally useful after a break or return
> 

This patch adds a compile warning.

> Signed-off-by: Athira Lekshmi C V <andnlnbn18@gmail.com>

Btw, signing and from should be your legal name that you would use for
signing a document.  The signed off by is supposed to mean that you
didn't violate copyrights.  If you normally sign with "C V" that's fine
as well.

regards,
dan carpenter

