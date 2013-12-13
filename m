Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3LMKvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:51:14 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48596 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3LMKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:51:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131213095655.GB4360@n2100.arm.linux.org.uk>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com>
	<20131213095655.GB4360@n2100.arm.linux.org.uk>
Date: Fri, 13 Dec 2013 11:51:09 +0100
Message-ID: <CACmBeS1d-EX5oPD8f7P-ufmF=MutdTO+LgG23Cb0=biR8yQPCg@mail.gmail.com>
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulli.kroll@googlemail.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 December 2013 10:56, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> So, having these symbols enabled (provided the right ones for FA526 are
> also enabled) makes no difference.  So I don't buy your explanation.

The explanation is indeed false, CPU_FA526 and CPU_ARM920T get along just fine.
That's not where the problem is.

Panic goes away after removing CONFIG_ARM_THUMB=y.

I assume this is what should happen on processors without thumb?

Thanks,
Jonas
