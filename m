Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3EPWNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:13:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:27930 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab3EPWNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:13:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="338560899"
Date: Fri, 17 May 2013 00:13:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] drivers, mfd: fix tps65912 link error when core mfd is a
 module
Message-ID: <20130516221305.GF22822@zurbaran>
References: <alpine.DEB.2.02.1304171428000.31235@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304171428000.31235@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Apr 17, 2013 at 02:28:47PM -0700, David Rientjes wrote:
> CONFIG_MFD_CORE must be statically linked if CONFIG_MFD_TPS65912 is
> selected, otherwise it results in a link error:
> 
> 	drivers/built-in.o: In function `tps65912_device_init':
> 	(.text+0x587e4): undefined reference to `mfd_add_devices'
> 	drivers/built-in.o: In function `tps65912_device_init':
> 	(.text+0x5884c): undefined reference to `mfd_remove_devices'
> 	drivers/built-in.o: In function `tps65912_device_exit':
> 	(.text+0x58878): undefined reference to `mfd_remove_devices'
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/mfd/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
Applied to mfd-fixes, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
