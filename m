Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3AXKfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:35:44 -0500
Received: from nbd.name ([46.4.11.11]:49345 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab3AXKfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:35:17 -0500
Message-ID: <51010DBF.5060302@phrozen.org>
Date: Thu, 24 Jan 2013 11:32:31 +0100
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Huacai Chen <chenhc@lemote.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Subject: Re: [PATCH V8 00/13] MIPS: Add Loongson-3 based machines support
References: <1352709169-3481-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1352709169-3481-1-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Huacai Chen(13):
>   MIPS: Loongson: Add basic Loongson-3 definition.
>   MIPS: Loongson: Add basic Loongson-3 CPU support.
>   MIPS: Loongson: Introduce and use cpu_has_coherent_cache feature.
>   MIPS: Loongson 3: Add Lemote-3A machtypes definition.
>   MIPS: Loongson: Add UEFI-like firmware interface support.
>   MIPS: Loongson 3: Add HT-linked PCI support.
>   MIPS: Loongson 3: Add IRQ init and dispatch support.
>   MIPS: Loongson 3: Add serial port support.
>   MIPS: Loongson: Add swiotlb to support big memory (>4GB).
>   MIPS: Loongson: Add Loongson-3 Kconfig options.
>   MIPS: Loongson 3: Add Loongson-3 SMP support.
>   MIPS: Loongson 3: Add CPU hotplug support.
>   MIPS: Loongson: Add a Loongson-3 default config file.
>
> Signed-off-by: Huacai Chen<chenhc@lemote.com>
> Signed-off-by: Hongliang Tao<taohl@lemote.com>
> Signed-off-by: Hua Yan<yanh@lemote.com>
> ---

Hi,

I have added all patches apart from 3/13 to my queue.

I believe "MIPS: Loongson: Introduce and use cpu_has_coherent_cache 
feature." should e rewritten in a saner way.

Please compile and runtime test the tree before I send it to Ralf
--> 
http://git.linux-mips.org/?p=john/linux-john.git;a=shortlog;h=refs/heads/mips-next-3.9

I cleaned up a few minor whitespace errors while merging.

http://patchwork.linux-mips.org/patch/4547/ has a few comments. Please 
prepare a patch asap to address those so i can fold it into the series.

	John
