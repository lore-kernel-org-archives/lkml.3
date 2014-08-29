Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaH2Mll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:41:41 -0400
Received: from thoth.sbs.de ([192.35.17.2]:38722 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbaH2Mlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:41:39 -0400
Message-ID: <540074FF.9080407@siemens.com>
Date: Fri, 29 Aug 2014 14:41:35 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jailhouse <jailhouse-dev@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: [ANNOUNCE] Jailhouse 0.1 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After its publication about 10 months ago, the Jailhouse partitioning
hypervisor for Linux [1] reached an important first milestone: all major
features required to use Jailhouse on Intel x86 CPUs are now available.
We are marking this point with a first release tag, v0.1.

This release particularly means full exploitation of VT-d DMA and
interrupt remapping to isolate assigned PCI devices from the hypervisor
and foreign cells. Moreover, the usability of Jailhouse was greatly
improved by the introduction and continuous extension of a generator for
system configuration files. Finally, a framework for writing basic cell
applications is available now. With a few lines of C code you can set up
timer interrupts, read clocks or configure PCI devices for the use in
simple bare-metal real-time applications.

The new release can be downloaded from

    https://github.com/siemens/jailhouse/archive/v0.1.tar.gz

It's easiest to try out in a virtual environment provided by QEMU/KVM,
see the included README. The braver ones can pick a real compatible
machine and let "jailhouse config create" provide a (generally) working
configuration. Be warned that real hardware tend to require some manual
post-processing of configuration files, for the demo cells or even the
system.

Check the project homepage at

    https://github.com/siemens/jailhouse

for the git repository, links to the mailing list and further
information. Don't hesitate to contact the development community on
questions, problems or suggestions.

There is still a bit work ahead to reach a version 1.0. In the near
future, we will look into integrating recently published contributions
of new architectures like AMD64 [1] and ARM 32-bit [2]. An inter-cell
communication mechanism will also be merged soon. Several features
particularly important for the use in safety-critical scenarios have
been identified and are being developed now.

Enabling Jailhouse as a certifiable component in safety-related systems
is our primary goal, though we are not excluding other use case like in
telecommunication, high-speed real-time control or scenarios we haven't
even thought of yet.

Last but not least: Many thanks to all who contributed code, reviews,
comments or sponsoring to the project! Your input was already very
valuable for the progress of Jailhouse. Keep it up!

Jan

[1] http://thread.gmane.org/gmane.comp.emulators.kvm.devel/116825
[2] http://thread.gmane.org/gmane.linux.jailhouse/601
[3] http://thread.gmane.org/gmane.linux.jailhouse/779

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux

