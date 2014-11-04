Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaKDNoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:44:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:51908 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaKDNn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:43:59 -0500
Date: Tue, 4 Nov 2014 10:42:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf tools: Add gzip decompression support for
 kernel module
Message-ID: <20141104134229.GF18464@kernel.org>
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
 <1415063674-17206-3-git-send-email-namhyung@kernel.org>
 <20141104110017.GB20829@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104110017.GB20829@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 04, 2014 at 12:00:17PM +0100, Jiri Olsa escreveu:
> On Tue, Nov 04, 2014 at 10:14:28AM +0900, Namhyung Kim wrote:
> > Now my Archlinux box shows module symbols correctly.
> 
> with the last comment addressed (-lz in test-all.bin):
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied the series.

- Arnaldo
