Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3IIMGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:06:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49251 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3IIMGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:06:12 -0400
Date: Mon, 9 Sep 2013 14:05:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chenggang Qin <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chenggang Qin <chenggang.qcg@taobao.com>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] perf core: avoid traverse dsos list while find vdso
Message-ID: <20130909120555.GU31370@twins.programming.kicks-ass.net>
References: <1378349975-3333-1-git-send-email-chenggang.qin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378349975-3333-1-git-send-email-chenggang.qin@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH 1/2] perf core: avoid traverse dsos list while find vdso

>  tools/perf/util/vdso.c |   22 ++++++++--------------

That's not perf core that's perf tools.
