Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936574Ab3DIJVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:21:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49880 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761587Ab3DIJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:21:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the final tree (probably arm-soc tree related)
Date: Tue, 9 Apr 2013 11:21:24 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130409190900.97dcf3a70a9c0ad727b8bc4b@canb.auug.org.au>
In-Reply-To: <20130409190900.97dcf3a70a9c0ad727b8bc4b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091121.24372.arnd@arndb.de>
X-Provags-ID: V02:K0:ffc4SjXk9IKJsGto9ZCEiWq0BI4MDzni2LHKHibn1fn
 iY1aiwEhu5kZh7Xe2jpOxCCurQ5TSnKOW4/HUS64ESEN4o+/PF
 bueUL+MYgT/N2U2N/yZD7puerNCMqOT+0I2H3O1/BJoaniycm2
 6aldchByzdRba+zbUtJFWVsha8neYgxi106w7C+afj4dTVCleU
 HRfelONNPb3A42WIt7sN3LPghkD3d0pYzd/CuhPURPHZYWEHal
 M5sB/hxuwABfK5GGknKKSpcXCXHHm89I8I1wuDlx5y/Da/vgr3
 ZuKzS/BEHMMu4qhCGh1LJ6wt32rqXhAmTH+4lm7A7Q7YZ7YgPB
 kvHNOA9I6ZOPGA5i9jdk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Stephen Rothwell wrote:
> After merging the final tree, today's linux-next build (arm defconfig)
> produced these warnings:
> 
> arch/arm/mach-cns3xxx/Kconfig:2:warning: choice value used outside its choice group
> arch/arm/mach-bcm2835/Kconfig:2:warning: choice value used outside its choice group
> arch/arm/Kconfig:287:error: recursive dependency detected!
> arch/arm/Kconfig:287:   choice <choice> contains symbol ARCH_CNS3XXX
> arch/arm/Kconfig:366:   symbol ARCH_CNS3XXX depends on ARCH_MULTI_V6
> arch/arm/Kconfig:933:   symbol ARCH_MULTI_V6 depends on ARCH_MULTIPLATFORM
> arch/arm/Kconfig:292:   symbol ARCH_MULTIPLATFORM is part of choice <choice>

Thanks for the notification, I think git rerere picked up a wrong conflict resolution
again that I did earlier. I'll fix it when I do the next pulls today.

	Arnd
