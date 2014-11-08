Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaKHDSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 22:18:34 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:46004 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaKHDSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 22:18:33 -0500
MIME-Version: 1.0
Date: Fri, 7 Nov 2014 22:18:32 -0500
Message-ID: <CALL1ybn2scmOyKom3cphHu+kzJyGv+4OGPmrwJN60GU1QhFTyA@mail.gmail.com>
Subject: Via Nano fails and completely crashes on kvm
From: Timothy McDaniel <timnboys@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Via Nano fails and completely crashes on kvm

here is my /proc/cpuinfo

processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 15
model name      : VIA Nano processor U2250 (1.6GHz Capable)
stepping        : 3
cpu MHz         : 800.000
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush acpi mmx fxsr sse sse2 ss tm pbe syscall nx lm
constant_tsc up rep_good nopl pni monitor vmx est tm2 ssse3 cx16 xtpr
rng rng_en ace ace_en ace2 phe phe_en lahf_lm
bogomips        : 3191.62
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

also here is my uname -mrs
Linux 3.2.0-4-amd64 x86_64

here is uname -a
Linux sd-24793 3.2.0-4-amd64 #1 SMP Debian 3.2.63-2+deb7u1 x86_64 GNU/Linux

please tell me if you need anymore info on helping me get kvm to work.
