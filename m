Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3JNOpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:45:06 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:57269 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3JNOpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:45:05 -0400
Date: Mon, 14 Oct 2013 11:44:54 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Chenggang Qin <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, root <root@core097011.sqa.cm4>,
        David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: Re: [PATCH 1/3] perf core: Fix a mmap and munmap mismatched bug
Message-ID: <20131014144454.GB11175@ghostprotocols.net>
References: <1381451279-4109-1-git-send-email-chenggang.qin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381451279-4109-1-git-send-email-chenggang.qin@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please use "perf tools: " as the prefix, I was assuming that "perf core:
" was related to the kernel code and was skipping those patches.

I'll fix up the prefix to use the standard used for the various files in
tools/perf, "perf symbols: " for this patch, for instance.

Applied this one and I'm checking the other patches from you, thanks,

- Arnaldo
