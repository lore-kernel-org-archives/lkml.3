Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3I0Odl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:33:41 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44297 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3I0Odh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:33:37 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 27 Sep 2013 15:33:16 +0100
X-Google-Sender-Auth: Y8kRbLUyVbnm4ckVLAYOt2Qq8oA
Message-ID: <CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
Subject: Re: [QUERY] Building and testing Aarch64
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27 September 2013 09:58, Ramkumar Ramachandra <artagnon@gmail.com> wrote:
> I'm interested in cross-compiling for ARM v8, and fixing some early
> papercuts to begin with; my host machine is a normal x86_64 box.
> Although I managed to use Linaro's toolchain [1] to build an Aarch64
> kernel, and found a suitable rootfs [2] to use it with, I am not able
> to find an ARM64 machine emulator. qemu-system-arm seems to emulate
> only a 32-bit ARM machine, and is hence unsuitable for the task. How
> is everyone else working on the /arch/arm64 tree?

Linaro has a page with links for running Linux on ARMv8

http://www.linaro.org/engineering/engineering-projects/armv8

ARM provides an emulator, ARMv8 Foundation Model (free as in free beer
but you need to register to be able to download, just like the
architecture documentation):

http://www.arm.com/products/tools/models/fast-models/foundation-model.php

I think the direct download link is at the bottom of the page:

https://silver.arm.com/browse/FM00A

-- 
Catalin
