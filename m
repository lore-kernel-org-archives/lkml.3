Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JHM1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:27:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3JHM1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:27:46 -0400
Message-ID: <1381235260.15686.38.camel@marge.simpson.net>
Subject: Re: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 14:27:40 +0200
In-Reply-To: <20131008121709.GA3955@infradead.org>
References: <1381221715.15686.3.camel@marge.simpson.net>
	 <20131008121709.GA3955@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:x/iwkQ3SBOOExD/xCIYzBVZpFBrMiuqSvQ1YxPrJTP5
 MWDg8Uxk8maA2udZyfznDZ7C5kHU9LtyziI6MZWHNASivrX7sB
 s1BN/mUpGlJKxQaVHlIPGIeUzzY02dEihPEbQXX9mSB4O2fQ4z
 Oh8JW1Q2j/yizQNILzHRkJTxexx6wf/+tjodj+d0yRG1hGUMwO
 IevCIaT6HQzRdWHJlVFKBYzKyDCTyLR4FeIrG76PDi79WbGUaE
 oKCM+UX+iSsaPYInTf3Rv0a8Gf4ipMZaJrrJq/Q7mA6klEtsJ6
 vD0mvel/rL6/h+dTYZIPY6gnsHnvx8fXj7LIvHfHREC9fp+vrP
 AmZArW11RXr1d21jtrp0+Z9fGD+8u/r6qUAL+f5WYOhVxbP+12
 kET74gQr7Htyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 09:17 -0300, Arnaldo Carvalho de Melo wrote: 
> Em Tue, Oct 08, 2013 at 10:41:55AM +0200, Mike Galbraith escreveu:
> > Box: Q6600
> > 
> > Reproducer:
> > perf sched record -- sleep 1
> > perf sched lat (boom)
> > 
> > The bisect winner:
> 
> Can you try with today's tip/perf/urgent branch?

Works fine.

-Mike

