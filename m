Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab3BHCTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:19:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:34495 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758192Ab3BHCTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:19:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,626,1355126400"; 
   d="scan'208";a="288107982"
Message-ID: <511460B7.4030007@linux.intel.com>
Date: Thu, 07 Feb 2013 18:19:35 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
CC: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sound/pci/asihpi/hpioctl.c:125:6: warning: cast to pointer from
 integer of different size
References: <51143ca4.bNX7TobZ2rDrz0zj%fengguang.wu@intel.com>
In-Reply-To: <51143ca4.bNX7TobZ2rDrz0zj%fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 03:45 PM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/mm
> head:   6fcddf474ae1c8e2fb5f14c850c8aa018e7a5034
> commit: 6fcddf474ae1c8e2fb5f14c850c8aa018e7a5034 x86-32: Add support for 64bit get_user()
> date:   2 hours ago
> config: make ARCH=i386 allmodconfig
> 
> All warnings:
> 
>    sound/pci/asihpi/hpioctl.c: In function 'asihpi_hpi_ioctl':
>>> sound/pci/asihpi/hpioctl.c:125:6: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>>> sound/pci/asihpi/hpioctl.c:126:6: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> --
>    net/atm/resources.c: In function 'atm_dev_ioctl':
>>> net/atm/resources.c:223:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>>> net/atm/resources.c:274:7: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> --

[... and so on ...]

Now I remember this problem.  I believe I discussed it with rmk in the
context of ARM, too.  Russell, did we ever find any way to implement
8-byte get_user() on 32 bits without massive warning spewage?

	-hpa


