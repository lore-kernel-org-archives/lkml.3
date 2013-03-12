Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3CLOX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:23:29 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36761 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CLOX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:23:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9ufsjGd9CvVf7y3jMXoN=rh7uc7jxiwZ9FHSeJ+XRzUQ@mail.gmail.com>
References: <CAPgLHd9ufsjGd9CvVf7y3jMXoN=rh7uc7jxiwZ9FHSeJ+XRzUQ@mail.gmail.com>
Date: Tue, 12 Mar 2013 15:23:26 +0100
Message-ID: <CAHTX3dJhPUm7Sk+Js2-UO=6zOfr-Z1ZKz6mGXYCYVP=bPx+exQ@mail.gmail.com>
Subject: Re: [PATCH -next] microblaze/PCI: remove duplicated include from pci-common.c
From: Michal Simek <monstr@monstr.eu>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/11 Wei Yongjun <weiyj.lk@gmail.com>:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove duplicated include.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  arch/microblaze/pci/pci-common.c | 1 -
>  1 file changed, 1 deletion(-)

Applied.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
