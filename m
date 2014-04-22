Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaDVA7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 20:59:06 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49933 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaDVA7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 20:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140422103223.f16654774d15a81410eaad22@canb.auug.org.au>
References: <20140422103223.f16654774d15a81410eaad22@canb.auug.org.au>
Date: Mon, 21 Apr 2014 17:59:01 -0700
Message-ID: <CADHgK6vPpNtKNmqcQgqDUHLSCM0DfDGbqcrXMaNkOpe+6ikR-Q@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the arm tree
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <linux@arm.linux.org.uk>, linux-next@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I'm not sure if this is helpful, but the virt_to_pfn macro added in
arch/arm/include/asm/memory.h:300 (I assume the 297 warning in yours),
in the hibernation patch:

#define virt_to_pfn(kaddr)      (__pa(kaddr) >> PAGE_SHIFT)

Should be removed as there is an improved version of virt_to_pfn for
arm in this commit: e26a9e00afc482b971afcaef1db8c9034d4d6d7c

Thanks,

Sebastian
