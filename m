Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaIKNnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:43:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:51811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaIKNnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:43:50 -0400
Date: Thu, 11 Sep 2014 10:43:38 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf top -g -U --sort=symbol --children == lalalalala?
Message-ID: <20140911134338.GE10158@kernel.org>
References: <1410263641.15383.8.camel@marge.simpson.net>
 <20140909133737.GK2773@kernel.org>
 <CAM9d7cgCuVVNrA7DU=t_CgENLa-dxRW2HXoO3Uo6=2izshSjhg@mail.gmail.com>
 <1410439392.20184.17.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410439392.20184.17.camel@marge.simpson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 11, 2014 at 02:43:12PM +0200, Mike Galbraith escreveu:
> On Thu, 2014-09-11 at 17:09 +0900, Namhyung Kim wrote: 
> > On Tue, Sep 9, 2014 at 10:37 PM, Arnaldo Carvalho de Melo
> > <acme@ghostprotocols.net> wrote:
> > > Em Tue, Sep 09, 2014 at 01:54:01PM +0200, Mike Galbraith escreveu:
> > >> Seems the now default on --children thingy doesn't like -U much.
> > >
> > > Namhyung, can you please take a look at this?
> > 
> > So what is the problem here?
> 
> Well, if you don't see anything wrong, I guess nothing at all.

:-)

I think that when we decide that it is so better to change defaults like
we did this time, we should be required to add a big fat warning (a
--tui popup, use the first lines on --stdio, etc) about why the default
was changed and allow quick, easy opt out, restoring previous behaviour
after the user, being warned, knows what to expect, tries it, and then
is in a better position to decide if keeping the new default is what is
desired.

- Arnaldo
 
> > >> Samples: 5K of event 'cycles', Event count (approx.): 2268660922
> > >>   Children      Self  Symbol
> > >> +   46.42%     0.04%  [k] system_call_fastpath
 
> I'll just turn it off until I figure out what cool stuff this is telling
> me. why that symbol becomes the number one hit, and why total% > 100.
 
> To me, it looks like top smoked it's breakfast, went to lala land ;-)

Yeah, its confusing, I'll let Namhyung explain it ;-)

:-)

- Arnaldo
