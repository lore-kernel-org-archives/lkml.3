Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaIHRlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:41:12 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:39793 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaIHRlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:41:10 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 8 Sep 2014 13:47:11 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: perf: perf_fuzzer triggers instant reboot
Message-ID: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

so I finally had time to run my perf_fuzzer again and it has rapidly 
turned up an alarming crash that instant-reboots my core2 test machine.

This is on 3.17-rc4.  It is reproducible.

The first time all that appeared on the serial console was:

[ 2616.535995] Kernel panic - not syncing: Lost physical address for unconsumed uncorrectable error

The second time this happened instead:

[  756.009271] traps: perf_fuzzer[4236] trap invalid opcode ip:4044c0 sp:7fffb0ed6f90 error:0
[  756.017590] BUG: unable to handle kernel paging request

I'll work on trying to narrow this down a bit.

Vince
