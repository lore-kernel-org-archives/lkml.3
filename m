Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3EPWNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:13:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:44196 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab3EPWNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:13:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="242694006"
Date: Fri, 17 May 2013 00:13:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Leon Romanovsky <leon@leon.nu>
Cc: sbkim73@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mfd: sec-core: Remove explicit call to
 mfd_remove_devices
Message-ID: <20130516221330.GH22822@zurbaran>
References: <1368630048-27007-1-git-send-email-leon@leon.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368630048-27007-1-git-send-email-leon@leon.nu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leon,

On Wed, May 15, 2013 at 06:00:48PM +0300, Leon Romanovsky wrote:
> In case mfd_add_devices will fail, it will call to mfd_remove_devices
> by itself and return non-zero value.
> 
> Signed-off-by: Leon Romanovsky <leon@leon.nu>
> ---
>  drivers/mfd/sec-core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
