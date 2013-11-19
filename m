Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3KSHrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:47:12 -0500
Received: from goliath.siemens.de ([192.35.17.28]:34927 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3KSHrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:47:09 -0500
Message-ID: <528B177B.5020604@siemens.com>
Date: Tue, 19 Nov 2013 08:47:07 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jailhouse <jailhouse-dev@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: [ANNOUNCE] Jailhouse: A Linux-based Partitioning Hypervisor
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are happy to announce the Jailhouse project, now also to a broader
community!

Jailhouse is a partitioning hypervisor that can create asymmetric
multiprocessing (AMP) setups on Linux-based systems. That means it runs
bare-metal applications or non-Linux OSes aside a standard Linux kernel
on one multicore hardware platform. Jailhouse ensures isolation between
these "cells", as we call them, via hardware-assisted virtualization.
The typical workloads we expect to see in non-Linux cells are
applications with highly demanding real-time, safety or security
requirements. In contrast to comparable hypervisors, Jailhouse is loaded
and configured via Linux, not the other way around. Give it a try to see
and "feel" the difference.

The aim of Jailhouse is to keep the amount of code responsible for
establishing and maintaining cell isolation as small as possible. And
with small we mean a few thousand lines of code at the privilege level
of the hypervisor. This is obviously much less than you can achieve with
full-featured hypervisors like KVM. See also the Jailhouse presentation
at this year's KVM Forum for the differentiation between KVM and
Jailhouse, as well as possible combinations of both:

https://docs.google.com/file/d/0B6HTUUWSPdd-Zl93MVhlMnRJRjg

Jailhouse is clearly in an incubator stage. We currently only support
Intel x86, including a demonstration setup inside QEMU/KVM. Also, we
still lack a number features and measures in order to truly and provably
isolate cells from each other. Besides working on this, ARM support is
on our road map as well. As we would like to motivate early feedback,
including potential contributions, we already released the code under GPLv2:

https://github.com/siemens/jailhouse

Aside the master branch, you can also find a first step towards the
KVM-on-Jailhouse concept presented at KVM Forum 2013.

Looking forward to your feedback!

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
