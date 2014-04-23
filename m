Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaDWNMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:12:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21870 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaDWNMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:12:53 -0400
Date: Wed, 23 Apr 2014 16:12:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anders Darander <anders.darander@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH linux-next v2] staging/rtl8821ae: fix sparse address
 space warning
Message-ID: <20140423131235.GX26890@mwanda>
References: <1398257986-21395-1-git-send-email-anders.darander@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398257986-21395-1-git-send-email-anders.darander@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 02:59:46PM +0200, Anders Darander wrote:
> Change the definition of pci_mem_start|end from correct from pci_io(un)map's
> point of view.
>

Terrific.  Thanks!

If you really wanted to then you could just delete pci_mem_end and also
you could remove all the casting of pci_mem_start in
drivers/staging/rtl8821ae/pci.h but this patch is an improvement on its
own so someone can do that later if they want.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

