Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaJUIMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:12:42 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:54988 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaJUIMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:12:39 -0400
Message-ID: <54461576.1060006@c-s.fr>
Date: Tue, 21 Oct 2014 10:12:38 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>
Subject: kernel 3.17 - perf build failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   LINK     perf
libperf.a(skip-callchain-idx.o): In function `arch_skip_callchain_idx':
/root/gen/trunk/knl/tools/perf/arch/powerpc/util/skip-callchain-idx.c:250: 
undefined reference to `pr_debug'
libperf.a(skip-callchain-idx.o): In function `check_return_addr':
/root/gen/trunk/knl/tools/perf/arch/powerpc/util/skip-callchain-idx.c:188: 
undefined reference to `pr_debug'
libperf.a(skip-callchain-idx.o): In function `arch_skip_callchain_idx':
/root/gen/trunk/knl/tools/perf/arch/powerpc/util/skip-callchain-idx.c:250: 
undefined reference to `pr_debug'
libperf.a(skip-callchain-idx.o): In function `check_return_addr':
/root/gen/trunk/knl/tools/perf/arch/powerpc/util/skip-callchain-idx.c:165: 
undefined reference to `pr_debug'
/root/gen/trunk/knl/tools/perf/arch/powerpc/util/skip-callchain-idx.c:171: 
undefined reference to `pr_debug'
libperf.a(skip-callchain-idx.o):/root/gen/trunk/knl/tools/perf/arch/powerpc/util/skip-callchain-idx.c:101: 
more undefined references to `pr_debug' follow
collect2: ld returned 1 exit status
make[1]: *** [perf] Error 1
make: *** [install] Error 2

