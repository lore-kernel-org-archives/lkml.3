Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaILCay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:30:54 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:51034 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaILCax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:30:53 -0400
Message-ID: <1410489049.5186.19.camel@marge.simpson.net>
Subject: Re: perf top -g -U --sort=symbol --children == lalalalala?
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2014 04:30:49 +0200
In-Reply-To: <20140911213027.GB1801@kernel.org>
References: <1410263641.15383.8.camel@marge.simpson.net>
	 <20140909133737.GK2773@kernel.org>
	 <CAM9d7cgCuVVNrA7DU=t_CgENLa-dxRW2HXoO3Uo6=2izshSjhg@mail.gmail.com>
	 <1410439392.20184.17.camel@marge.simpson.net>
	 <20140911134338.GE10158@kernel.org> <20140911213027.GB1801@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 18:30 -0300, Arnaldo Carvalho de Melo wrote:

> Also, looking at the changelog entries and at tools/perf/Documentation/
> the only description for --children, the default, is:
> 
> ----------------
> --children::
>         Accumulate callchain of children to parent entry so that then can
>         show up in the output.  The output will have a new "Children" column
>         and will be sorted on the data.  It requires callchains are recorded.
> ----------------

grep of course found that, and git log found more, but nothing told me
what the heck it's sweeping up that's so darn plentiful in my box that
there's more than 100% of it laying about :)

> I think that a longer/clearer entry in the 'perf record' man page is
> required.
> 
> Perhaps the description got lost in a --cover-letter for the patch
> series implementing it?

If it ever existed, I can't find it.  A little blurb would be helpful.

-Mike

