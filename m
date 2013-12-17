Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3LQNlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:41:42 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49919 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3LQNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:41:40 -0500
Date: Tue, 17 Dec 2013 14:41:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, namhyung@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com
Subject: Re: [PATCH 5/5 v2] perf timechart: add emphasize option
Message-ID: <20131217134137.GA29396@gmail.com>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
 <20131216193800.GA19283@ghostprotocols.net>
 <20131217093855.GA3345@stfomichev-desktop>
 <20131217112303.GB27791@gmail.com>
 <20131217121522.GA6357@stfomichev-desktop>
 <20131217133821.GA6517@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217133821.GA6517@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Tue, Dec 17, 2013 at 04:15:22PM +0400, Stanislav Fomichev escreveu:
> > > Please give a sample usage command line and a sample output. (the 
> > > highlighting can be done using ASCII escape sequences in the changelog 
> > > as well.)
> > Highlighting is done in the generated SVG, so I can't really show it in
> > the log or documentation. But I added simple example with -e option.
> > 
> > >   -e::
> > >   --emphasize=<duration_nsecs|task_name>::
> > Thanks, added.
> 
> I also wonder how to allocate single letter options here... can we live
> with just --emphasize for now? Wouldn't at some point we maybe want to
> use -e in 'perf timechart' to pick some specific event, and then, to
> make it consistent with the other tools, -e would then be used?

I wanted to raise a similar argument too - so if we don't have to do 
-e then maybe '--grep' would be the better option name?

If it becomes popular then the pattern matching can be improved, 
without having to change the option name and such.

Thanks,

	Ingo
