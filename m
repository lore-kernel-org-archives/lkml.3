Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab3CITiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 14:38:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43324 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3CITiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 14:38:17 -0500
Message-ID: <513B8FA7.9040200@googlemail.com>
Date: Sat, 09 Mar 2013 19:38:15 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: linux-3.9.0-rc1+: Output from "make kernelrelease"contains incorrect
 data
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Linus' current tree, the first time the command "make kernelrelease" 
is run after building a kernel, the output contains some unwanted text. 
Subsequent uses of the command produce the expected output. This appears 
to be a regression - 3.8.2 does not have this problem.

This is easily demonstrated from the command line by the following:

<build the kernel>
...
System is 2311 kB
CRC a4e38b86
Kernel: arch/x86/boot/bzImage is ready  (#186)
$ make kernelrelease
scripts/kconfig/conf --silentoldconfig Kconfig 3.9.0-rc1+
$ make kernelrelease
3.9.0-rc1+

Happy to test the fix.

Chris



