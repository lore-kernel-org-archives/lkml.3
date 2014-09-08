Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaIHOMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:12:52 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:52352 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaIHOMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:12:51 -0400
Message-ID: <540DB95F.6070609@imgtec.com>
Date: Mon, 8 Sep 2014 15:12:47 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Release of Linux MTI-3.14-LTS kernel
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imagination Technologies is pleased to announce the release of its 3.14
LTS (Long-Term Support) MIPS kernel. The changelog below is based off
the stable Linux 3.14.10 release done by Greg Kroah-Hartman in commit
bbae7add628cfe96a1facd578dd1eddcd1030de7 back on June 30th. The code
repository is hosted at the Linux/MIPS project GIT:

http://git.linux-mips.org/?p=linux-mti.git;a=shortlog;h=refs/heads/linux-mti-3.14

We look forward to any comments or feedback.

        The Imagination MIPS Kernel Team


ChangeLog:

Upstream:
- Move to Linux 3.14.10

Userland visible changes:
- MIPS 32/64 seccomp support
- Do not set any FCSR cause bits from userland

Boot setup related changes:
- SMP/CPS support
- Deprecate SMP/CMP

New drivers and features:
- m5150 support
- p5600 support
- perf support for interAptiv/proAptiv/p5600
- EVA support
- Malta power management support
- Malta powering down support
- Hardware Table Walker support
- MAAR support
- Dedicated RI/XI exception handlers
- Hotplug support
- cpuidle support

Developer visible changes:
- SMTC removal
- Enable DEVTMPFS on malta_defconfigs
- Add more microassembler instructions
- 16K by default on Malta SMP defconfigs
- Set max cpus to 8 on Malta SMP defconfigs

Fixes:
- Detect instruction cache aliases
- Fix 1074K CPU support
- GIC fixes
- KVM T&E fixes
- sead3/BE networking fix
- Misc other code fixes, build fixes and cleanups

-- 
markos
