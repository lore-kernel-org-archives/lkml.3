Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaF0VQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:16:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:36700 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaF0VQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:16:27 -0400
Date: Fri, 27 Jun 2014 18:16:21 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] perf trace: add pagefault statistics
Message-ID: <20140627211621.GI18773@kernel.org>
References: <1403799268-1367-1-git-send-email-stfomichev@yandex-team.ru>
 <1403799268-1367-5-git-send-email-stfomichev@yandex-team.ru>
 <20140626194115.GE18773@kernel.org>
 <20140627084307.GF21788@stfomichev-desktop.yandex.net>
 <20140627135330.GF18773@kernel.org>
 <20140627154417.GH21788@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627154417.GH21788@stfomichev-desktop.yandex.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 27, 2014 at 07:44:17PM +0400, Stanislav Fomichev escreveu:
> On Fri, Jun 27, 2014 at 10:53:30AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jun 27, 2014 at 12:43:07PM +0400, Stanislav Fomichev escreveu:
> > > > Where is it?
> > > >  usleep (19155), 151 events, 84.4%, 0:68 faults, 0.000 msec
> > >                                       ^^^^^^^^^^^
> > > 				      maj:min

> > Ok, thanks for the explanation, I'll add that to the commit log and
> > check if the documentation mentions that in the statistics section.

> Currently, there is no documentation for statistics.
> Maybe it makes sense to split this cryptic message into
> "0 majfaults, 68 minfauls" and then we don't even need to have
> documentation at all?

I guess this is a good step, i.e. to add it in the same way as existing
events, the syscalls.

At some point we should add docs about the statistics.

- Arnaldo
