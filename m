Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaFPI05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:26:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33751 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaFPI04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:26:56 -0400
Date: Mon, 16 Jun 2014 11:26:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vitaly Osipov <vitaly.osipov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: remove memset(0) after LIBCFS_ALLOC
Message-ID: <20140616082651.GE5500@mwanda>
References: <20140614072951.GA87525@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614072951.GA87525@witts-MacBook-Pro.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 05:29:51PM +1000, Vitaly Osipov wrote:
> Joe Perches mentioned on driverdev-devel that memset after LIBCFS_ALLOC
> is not necessary as it is already done during LIBCFS_ALLOC_POST. This
> commit removes these unnecessary memsets. Based on the results of running 
> a cocci patch along the lines of:
> 
> @@
> expression E1, E2;
> @@
> 
> LIBCFS_ALLOC (E1,E2);
> ...
> - memset(E1,0,E2);
> 
> Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

