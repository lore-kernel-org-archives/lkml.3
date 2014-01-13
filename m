Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaAMI7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:59:15 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64617 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaAMI7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:59:12 -0500
X-AuditID: 9c93017d-b7b41ae000004b3e-3c-52d3aadec8ec
From: Namhyung Kim <namhyung@kernel.org>
To: Gaurav Jain <gjain@fb.com>
Cc: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] perf tools: Synthesize anon MMAP records on the heap
References: <1389501134-13116-1-git-send-email-gjain@fb.com>
Date: Mon, 13 Jan 2014 17:59:10 +0900
In-Reply-To: <1389501134-13116-1-git-send-email-gjain@fb.com> (Gaurav Jain's
	message of "Sat, 11 Jan 2014 20:32:14 -0800")
Message-ID: <87fvosb6ld.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gaurav,

On Sat, 11 Jan 2014 20:32:14 -0800, Gaurav Jain wrote:
> Anon records usually do not have the 'execname' entry. However if they are on
> the heap, the execname shows up as '[heap]'. The fix considers any executable
> entries in the map that do not have a name or are on the heap as anon records
> and sets the name to '//anon'.
>
> This fixes JIT profiling for records on the heap.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
