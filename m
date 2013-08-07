Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3HGUXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:23:12 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:63159 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab3HGUXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:23:10 -0400
Date: Wed, 7 Aug 2013 17:16:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v2 1/2] perf tools: Add support for pinned modifier
Message-ID: <20130807201624.GG2665@ghostprotocols.net>
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
 <20130806135937.GB1068@krava.brq.redhat.com>
 <20130807051957.GC19998@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807051957.GC19998@concordia>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 03:19:57PM +1000, Michael Ellerman escreveu:
> On Tue, Aug 06, 2013 at 03:59:37PM +0200, Jiri Olsa wrote:
> > On Tue, Aug 06, 2013 at 11:28:05PM +1000, Michael Ellerman wrote:
> > > +		if (evsel->leader == evsel)
> > > +			evsel->attr.pinned = mod.pinned;

> > nitpick, we have perf_evsel__is_group_leader for this check
 
> Ah darn, missed it.

> Should I do a respin?

No need, I did it.

- Arnaldo
