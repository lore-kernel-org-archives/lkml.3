Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaEEMpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:45:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaEEMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:45:42 -0400
Date: Mon, 5 May 2014 14:45:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 10/10] perf tools: Move ACCESS_ONCE from perf.h header
Message-ID: <20140505124536.GN26782@laptop.programming.kicks-ass.net>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
 <1399293219-8732-11-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399293219-8732-11-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 02:33:39PM +0200, Jiri Olsa wrote:
> Into util/evlist.h header as it's the only user
> of this define.

One could argue its part of the barrier muck, but sure.
