Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab3ICJBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:01:34 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64948 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3ICJBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:01:33 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-37-5225a5692d14
From: Namhyung Kim <namhyung@kernel.org>
To: Chenggang Qin <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, root <root@core097011.sqa.cm4>,
        David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: Re: [PATCH 1/3] perf core: Fix a mmap and munmap mismatched bug
References: <1378049385-4466-1-git-send-email-chenggang.qin@gmail.com>
Date: Tue, 03 Sep 2013 18:01:29 +0900
In-Reply-To: <1378049385-4466-1-git-send-email-chenggang.qin@gmail.com>
	(Chenggang Qin's message of "Sun, 1 Sep 2013 23:29:43 +0800")
Message-ID: <87zjruth1y.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chenggang,

On Sun,  1 Sep 2013 23:29:43 +0800, Chenggang Qin wrote:
> From: root <root@core097011.sqa.cm4>
>
> In function filename__read_debuglink(), while the ELF file is opend and mmapped
> in elf_begin(), but if this file is considered to not be usable during the
> following code, we will goto the close(fd) directly. The elf_end() is skipped.
> So, the mmaped ELF file cannot be munmapped. The memory areas are mmapped is
> exist during the life of perf. This is a memory leak.
> This patch fixed this bug.
> Thanks.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
