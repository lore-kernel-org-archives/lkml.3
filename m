Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3LQN7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:59:31 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:50918 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3LQN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:59:30 -0500
Date: Tue, 17 Dec 2013 10:59:23 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, namhyung@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com
Subject: Re: [PATCH 5/5 v2] perf timechart: add emphasize option
Message-ID: <20131217135923.GB6517@ghostprotocols.net>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
 <20131216193800.GA19283@ghostprotocols.net>
 <20131217093855.GA3345@stfomichev-desktop>
 <20131217112303.GB27791@gmail.com>
 <20131217121522.GA6357@stfomichev-desktop>
 <20131217133821.GA6517@ghostprotocols.net>
 <20131217134137.GA29396@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217134137.GA29396@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 17, 2013 at 02:41:37PM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > Em Tue, Dec 17, 2013 at 04:15:22PM +0400, Stanislav Fomichev escreveu:
> > > > Please give a sample usage command line and a sample output. (the 
> > > > highlighting can be done using ASCII escape sequences in the changelog 
> > > > as well.)
> > > Highlighting is done in the generated SVG, so I can't really show it in
> > > the log or documentation. But I added simple example with -e option.

> > > >   -e::
> > > >   --emphasize=<duration_nsecs|task_name>::
> > > Thanks, added.

> > I also wonder how to allocate single letter options here... can we live
> > with just --emphasize for now? Wouldn't at some point we maybe want to
> > use -e in 'perf timechart' to pick some specific event, and then, to
> > make it consistent with the other tools, -e would then be used?
 
> I wanted to raise a similar argument too - so if we don't have to do 
> -e then maybe '--grep' would be the better option name?
 
> If it becomes popular then the pattern matching can be improved, 
> without having to change the option name and such.

Humm, 'grep' is a filter, i.e. something that removes parts of the data
being perused, while this case it will not filter anything, it will just
make something that matches some search criteria to stand out from the
rest, that is still there, so perhaps --emphasize is Ok albeit kinda
long...

Do we have any other command line tool that has a long standing
semantics of "highlighting" or "emphasizing" parts of a data stream?

- Arnaldo
