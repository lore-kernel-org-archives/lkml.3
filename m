Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaIKMn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:43:27 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:58444 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaIKMnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:43:24 -0400
Message-ID: <1410439392.20184.17.camel@marge.simpson.net>
Subject: Re: perf top -g -U --sort=symbol --children == lalalalala?
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 11 Sep 2014 14:43:12 +0200
In-Reply-To: <CAM9d7cgCuVVNrA7DU=t_CgENLa-dxRW2HXoO3Uo6=2izshSjhg@mail.gmail.com>
References: <1410263641.15383.8.camel@marge.simpson.net>
	 <20140909133737.GK2773@kernel.org>
	 <CAM9d7cgCuVVNrA7DU=t_CgENLa-dxRW2HXoO3Uo6=2izshSjhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 17:09 +0900, Namhyung Kim wrote: 
> On Tue, Sep 9, 2014 at 10:37 PM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Tue, Sep 09, 2014 at 01:54:01PM +0200, Mike Galbraith escreveu:
> >> Seems the now default on --children thingy doesn't like -U much.
> >
> > Namhyung, can you please take a look at this?
> 
> So what is the problem here?

Well, if you don't see anything wrong, I guess nothing at all.

> >> Samples: 5K of event 'cycles', Event count (approx.): 2268660922
> >>   Children      Self  Symbol
> >> +   46.42%     0.04%  [k] system_call_fastpath

I'll just turn it off until I figure out what cool stuff this is telling
me. why that symbol becomes the number one hit, and why total% > 100.

To me, it looks like top smoked it's breakfast, went to lala land ;-)

-Mike

