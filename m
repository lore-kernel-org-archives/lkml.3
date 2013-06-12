Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3FLAOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:14:19 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:41758 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab3FLAOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:14:18 -0400
Message-ID: <51B7BD57.7050406@tlinx.org>
Date: Tue, 11 Jun 2013 17:14:15 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: mod filenames != modnames? (inconsistent name changing)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should we have any expectation that a module name and it's filename
should be equivalent?

I was writing an auto-complete script for modprobe so it wouldn't give
me the option to double load a module (I'd have to manually type it in if
I really wanted it).

Trouble is some modules with names w/underscores ('_') change
register their names with a 'dash'.

Would it be too much trouble to ask that the same names be used in
both places?

I have about 30 modules loaded now and out of that list,
2 are name changes:

acpi_cpufreq  (filename acip-cpufreq.ko)
kvm_intel     (filename kvm-intel.ko)

If I load a bunch more... I find more that change names.

Could the naming in the modules that do this be made consistent?

Not doing so makes automatically tying a mod-name to it's file
tend toward being non-deterministic.

Many modules use '-' or '_' without being confused.
It would be helpful if the few confused modules could
get their identity straight.  Is there a problem with
making these names consistent?



