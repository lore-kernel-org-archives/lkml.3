Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3GIAfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:35:52 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:60477 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3GIAfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:35:51 -0400
MIME-Version: 1.0
Date: Tue, 9 Jul 2013 10:35:49 +1000
Message-ID: <CAPM=9twiAK18Ny7QMMZA+DHFB=wQ2pxg8rDV+vj91TJjd_e2fg@mail.gmail.com>
Subject: sending SEGV to qemu crashes host kernel in Fedora 19
From: Dave Airlie <airlied@gmail.com>
To: qemu-devel@nongnu.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

F19
kernel-3.9.8-300.fc19.x86_64
qemu-kvm-1.4.2-4.fc19.x86_64

If I start a complete F19 install in the guest and send the qemu
process a SEGV signal, the host kernel starts giving me random kmalloc
errors soon after, if I send a normal kill signal things seem fine.

CPU is Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz, on a HP 220z workstation.

I initially blamed bad RAM but this reproduces everytime, and I
swapped DIMMs around

I haven't tested with upstream kernel/qemu yet, but I wondered if
anyone else has seen this.

I noticed this because some work I was doing was segfaulting my qemu
and then my machine would die a few mins later.

Dave.
