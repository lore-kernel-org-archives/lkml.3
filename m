Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3I1IVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:21:30 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50356 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3I1IV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:21:27 -0400
X-Auth-Info: netPuYzOAC97FhbtSefm2n6VnmGQIVsl1pdwORdmUWc=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Building and testing Aarch64
References: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
	<CAHkRjk5_ep4poYY9gzcDgqaPuDtz2sgeZ0KPO6TqHttj-cS3xw@mail.gmail.com>
	<CALkWK0=YdxF43RQ-Fddp4Rzmx3aU3QdOPrjR=X+s6Wt9_RAYUg@mail.gmail.com>
	<20130927150156.GE26069@arm.com>
	<CALkWK0mjmGmhYnxBdMzbCXJn5yQyK63Ptqr6wT1pBurZCNtmNA@mail.gmail.com>
X-Yow: It's the RINSE CYCLE!!  They've ALL IGNORED the RINSE CYCLE!!
Date: Sat, 28 Sep 2013 10:21:18 +0200
In-Reply-To: <CALkWK0mjmGmhYnxBdMzbCXJn5yQyK63Ptqr6wT1pBurZCNtmNA@mail.gmail.com>
	(Ramkumar Ramachandra's message of "Sat, 28 Sep 2013 13:27:07 +0530")
Message-ID: <m2wqm1s6f5.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra <artagnon@gmail.com> writes:

> I'm not exactly sure what went wrong: I made sure to compile my kernel
> with virtio support.

Make sure you have CONFIG_VIRTIO_MMIO enabled.

> Also, I didn't understand the part of your Makefile that deals with
> the filesystem: what is filesystem.cpio.gz, and where is it going to
> be used?

It is the optional initrd.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
