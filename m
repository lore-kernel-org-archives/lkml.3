Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab3E1Isj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:48:39 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:41275 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612Ab3E1Ish (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:48:37 -0400
Date: Tue, 28 May 2013 10:48:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 3/5] perf gtk/hists: Display callchain overhead also
Message-ID: <20130528084833.GA30172@gmail.com>
References: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
 <1369211258-3163-4-git-send-email-namhyung@kernel.org>
 <20130522095215.GA2386@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522095215.GA2386@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Wed, May 22, 2013 at 05:27:36PM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Add a new column for showing callchain overhead.  I feel like it's
> > more natural than having those overhead next to a first child in a
> > same column.
> 
> Callchains in GTK, great! Some observations tho:
> 
> All those leaves with 0.00% looks ugly/not needed, right?
> 
> I took a screenshot and put at:
> 
> http://vger.kernel.org/~acme/perf-gtk-callchains.png

Looks really nice!

I'm wondering, would it be hard to add alternating lightgrey+white 
background colors to make the entries striped and for the horizontal 
structure to thus stand out better?

The 'qgit' tool does that for example, to alternate git commit log 
entries.

(Extra points for striping only where the line actually begins.)

Thanks,

	Ingo
