Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740Ab3EAKeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:34:17 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:64903 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3EAKeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:34:06 -0400
Date: Wed, 1 May 2013 12:34:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv4] perf: Fix vmalloc ring buffer pages handling
Message-ID: <20130501103401.GC17360@gmail.com>
References: <20130312135219.GA32001@krava.brq.redhat.com>
 <1363101972.24558.3.camel@laptop>
 <20130312153609.GC32001@krava.brq.redhat.com>
 <1363105490.24558.12.camel@laptop>
 <20130312170416.GD32001@krava.brq.redhat.com>
 <20130313111557.GC1064@krava.brq.redhat.com>
 <20130318190548.GA18920@krava.brq.redhat.com>
 <1363693618.22553.33.camel@laptop>
 <20130319143509.GA1128@krava.brq.redhat.com>
 <20130430153653.GD12715@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430153653.GD12715@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Mar 19, 2013 at 03:35:09PM +0100, Jiri Olsa wrote:
> > On Tue, Mar 19, 2013 at 12:46:58PM +0100, Peter Zijlstra wrote:
> > > 
> > > > are you going to include that, or should I repost it?
> > > 
> > > Ah, please repost (and prettify) it, I'm still very limited in the
> > > amount of work that I can do :/
> > > 
> > 
> > ok, attached
> 
> Ingo, Peter,
> 
> could this be pulled in?

Yeah, Peter acked it - I will pick it up.

Thanks,

	Ingo
