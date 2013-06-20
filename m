Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab3FTO60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:58:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab3FTO6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:58:24 -0400
Date: Thu, 20 Jun 2013 16:58:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Robert Richter <rric@kernel.org>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH] perf tools: Fix output directory of Documentation/
Message-ID: <20130620145815.GD1083@krava.brq.redhat.com>
References: <1367865614-30876-1-git-send-email-rric@kernel.org>
 <20130620134154.GC1083@krava.brq.redhat.com>
 <20130620145222.GA4767@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620145222.GA4767@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 11:52:22AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jun 20, 2013 at 03:41:54PM +0200, Jiri Olsa escreveu:
> > hi,
> > looks like this one is breaking the 'make install' for perf with:
> >     XMLTO perf-diff.1
> > usage: xmlto [OPTION]... FORMAT XML
> > OPTIONs are:
> >   -v              verbose output (-vv for very verbose)
> > make: *** [install-doc] Error 2
> > ------------------------------------------------------------------------
> > 
> > I bistected the issue to this one.. it works after I reverted it
> > 
> > 'make -f tests/make' test catches this error ;-)
> 
> Humm, I did use it, running it again to see why I didn't notice this
> problem...

argghhh it does not.. sry ;) I just recalled our previous conversation:

<jolsa>  'make -f tests/make' should catch it ;)
<jolsa>  nope, it does not
<jolsa>  will fix it ... the tests/make
...

I thought I posted it.. and I did not.. I will ;-)

Anyway the install-doc is broken..

jirka
