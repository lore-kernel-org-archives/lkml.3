Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3I1JK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 05:10:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52017 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3I1JKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 05:10:24 -0400
X-Auth-Info: N6cqqZWrfWjhiR8VgYxfwR3HBBRg7VeQx5aSrAW/sgs=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Building and testing Aarch64
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
	<CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
	<CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
	<20130927150156.GE26069@arm.com>
	<CALkWK0mjmGmhYnxBdMzbCXJn5yQyK63Ptqr6wT1pBurZCNtmNA@mail.gmail.com>
	<m2wqm1s6f5.fsf@linux-m68k.org>
	<CALkWK0nzk6s-C97ze4Ev8gY6fwPbf-qRCfCDvDDE56HFxvzw0A@mail.gmail.com>
X-Yow: Is this BOISE??
Date: Sat, 28 Sep 2013 11:10:09 +0200
In-Reply-To: <CALkWK0nzk6s-C97ze4Ev8gY6fwPbf-qRCfCDvDDE56HFxvzw0A@mail.gmail.com>
	(Ramkumar Ramachandra's message of "Sat, 28 Sep 2013 14:06:00 +0530")
Message-ID: <m2siwps45q.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra <artagnon@gmail.com> writes:

> Is there a bug in the Kconfig dependency tree? Sounds like VIRTIO_MMIO
> requires some vga (?) drivers to be compiled in as well.

I don't have any VGA option enabled.  You should use a serial console
with CONFIG_SERIAL_AMBA_PL011_CONSOLE.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
