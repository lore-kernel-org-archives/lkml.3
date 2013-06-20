Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3FTOwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:52:30 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:46736 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3FTOw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:52:28 -0400
Date: Thu, 20 Jun 2013 11:52:22 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Robert Richter <rric@kernel.org>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH] perf tools: Fix output directory of Documentation/
Message-ID: <20130620145222.GA4767@ghostprotocols.net>
References: <1367865614-30876-1-git-send-email-rric@kernel.org>
 <20130620134154.GC1083@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620134154.GC1083@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 20, 2013 at 03:41:54PM +0200, Jiri Olsa escreveu:
> hi,
> looks like this one is breaking the 'make install' for perf with:
>     XMLTO perf-diff.1
> usage: xmlto [OPTION]... FORMAT XML
> OPTIONs are:
>   -v              verbose output (-vv for very verbose)
> make: *** [install-doc] Error 2
> ------------------------------------------------------------------------
> 
> I bistected the issue to this one.. it works after I reverted it
> 
> 'make -f tests/make' test catches this error ;-)

Humm, I did use it, running it again to see why I didn't notice this
problem...

- Arnaldo
