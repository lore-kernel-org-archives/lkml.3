Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3I0OoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:44:05 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35706 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3I0OoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:44:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
 <CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 27 Sep 2013 20:13:21 +0530
Message-ID: <CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
Subject: Re: [QUERY] Building and testing Aarch64
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Catalin Marinas wrote:
> ARM provides an emulator, ARMv8 Foundation Model (free as in free beer
> but you need to register to be able to download, just like the
> architecture documentation):
>
> http://www.arm.com/products/tools/models/fast-models/foundation-model.php

I downloaded the foundation model and ran:

  $ ./Foundation_v8 --image linux-system-foundation.axf --block-device
debian-arm-rootfs

as described in the Debian page [1]. However, I didn't understand how
to boot it up with the kernel I just built with my toolchain
(arch/arm64/boot/Image.gz). What is this linux-system-foundation.axf?
Also, what is libarmctmodel.so?

Thanks.

[1]: https://wiki.debian.org/Arm64Port#Pre-built_Rootfs
