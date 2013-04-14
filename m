Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3DNBE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 21:04:29 -0400
Received: from plane.gmane.org ([80.91.229.3]:54081 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab3DNBE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 21:04:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Akemi Yagi <amyagi@gmail.com>
Subject: Error in linux-3.0.73 build
Date: Sun, 14 Apr 2013 01:04:12 +0000 (UTC)
Message-ID: <kkcvac$618$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 99-30-176-128.lightspeed.sndgca.sbcglobal.net
User-Agent: Pan/0.135 (Tomorrow I'll Wake Up and Scald Myself with Tea; GIT
	30dc37b master)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just tried to build from the linux-3.0.73 source tarball and got the following error:

arch/x86/mm/numa_32.c:107: error: redefinition of 'alloc_remap'
include/linux/bootmem.h:144: note: previous definition of 'alloc_remap' was here
make[2]: *** [arch/x86/mm/numa_32.o] Error 1
make[1]: *** [arch/x86/mm] Error 2
make: *** [arch/x86] Error 2

This only affects the 32-bit build of the kernel with the RHEL-6 configuration.

Akemi
The ELRepo Team.

