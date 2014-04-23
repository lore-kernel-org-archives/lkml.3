Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaDWMbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:31:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaDWMa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:30:58 -0400
Date: Wed, 23 Apr 2014 15:30:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anders Darander <anders.darander@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH][linux-next] staging/rtl8821ae: fix sparse address space
 warning
Message-ID: <20140423123044.GW26890@mwanda>
References: <1398254785-2484-1-git-send-email-anders.darander@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398254785-2484-1-git-send-email-anders.darander@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 02:06:25PM +0200, Anders Darander wrote:
> When unmapping the pci memory, the pointer was explicitly casted to void*,
> thus omitting the __iomem designation.

It looks like the struct definition should be updated instead of every
single reference being casted.

regards,
dan carpenter

