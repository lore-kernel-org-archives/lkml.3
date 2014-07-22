Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaGVOLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:11:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaGVOLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:11:42 -0400
Date: Tue, 22 Jul 2014 16:11:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/52] perf tools: Fix jump label always changing during
 tracing
Message-ID: <20140722141135.GF3935@laptop>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-2-git-send-email-adrian.hunter@intel.com>
 <20140722140034.GE20303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722140034.GE20303@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 11:00:34AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jul 22, 2014 at 04:17:10PM +0300, Adrian Hunter escreveu:
> > Intel PT decoding walks the object code to reconstruct
> > the trace.  A jump label change during tracing causes
> > decoding errors.

You'd better fix that, jump_labels can change any time and they're all
over the frigging place.
