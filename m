Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3I0I7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:59:21 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58443 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3I0I7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:59:16 -0400
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 27 Sep 2013 14:28:35 +0530
Message-ID: <CALkWK0mwRbBkM=qvQPoyR+kEs8HwLx9P7bWWQnst_Z1=DRFkRA@mail.gmail.com>
Subject: [QUERY] Building and testing Aarch64
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm interested in cross-compiling for ARM v8, and fixing some early
papercuts to begin with; my host machine is a normal x86_64 box.
Although I managed to use Linaro's toolchain [1] to build an Aarch64
kernel, and found a suitable rootfs [2] to use it with, I am not able
to find an ARM64 machine emulator. qemu-system-arm seems to emulate
only a 32-bit ARM machine, and is hence unsuitable for the task. How
is everyone else working on the /arch/arm64 tree?

Thanks.

[1]: https://aur.archlinux.org/packages/gcc-aarch64-linaro/
[2]: http://people.debian.org/~wookey/bootstrap/rootfs/
