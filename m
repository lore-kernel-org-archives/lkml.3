Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046Ab3JPT0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:26:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3JPT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:26:49 -0400
Date: Wed, 16 Oct 2013 12:26:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>
Subject: Re: [PATCH -next] misc: fix various misc/mic/host/ build errors
Message-ID: <20131016192648.GA19637@kroah.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C481E.1010908@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525C481E.1010908@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 12:38:06PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix various build errors (on x86_64) for drivers/misc/mic/host/:
> 
>   drivers/misc/mic/host/mic_main.c:378:3: error: too many arguments to function 'sysfs_get_dirent'
>   drivers/misc/mic/host/mic_intr.h:134:58: warning: 'struct pci_dev' declared inside parameter list [enabled by default]
>   drivers/misc/mic/host/mic_intr.h:134:58: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>   drivers/misc/mic/host/mic_intr.h:135:58: warning: 'struct pci_dev' declared inside parameter list [enabled by default]
>   drivers/misc/mic/host/mic_device.h:169:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
>   drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_read':
>   drivers/misc/mic/host/mic_device.h:169:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
>   drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_write':
>   drivers/misc/mic/host/mic_device.h:183:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
> Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Nikhil Rao <nikhil.rao@intel.com>
> Cc: Sudeep Dutt <sudeep.dutt@intel.com>

This is a -next issue only at this point in time, I thought it was in
the -next tree as a "fixup" already?

