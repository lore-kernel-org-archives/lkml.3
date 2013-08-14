Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab3HNONL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:13:11 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:49157 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab3HNONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:13:08 -0400
Date: Wed, 14 Aug 2013 11:13:01 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130814141301.GA2138@ghostprotocols.net>
References: <20130805083132.GE26746@gmail.com>
 <20130805083434.GA20606@infradead.org>
 <20130805090857.GA26940@gmail.com>
 <20130806061932.GA20485@infradead.org>
 <20130812181956.GB19405@gmail.com>
 <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy>
 <20130813104821.GB2170@gmail.com>
 <20130813121141.GB2188@ghostprotocols.net>
 <20130813160043.GB5280@gmail.com>
 <alpine.DEB.2.02.1308131749330.9154@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308131749330.9154@pianoman.cluster.toy>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 13, 2013 at 05:57:16PM -0400, Vince Weaver escreveu:
> On Tue, 13 Aug 2013, Ingo Molnar wrote:
> > that can only be addressed by either extending 'perf test' or by testing 
> > libpfm et al sooner. The upstream kernel can only address regressions that 
> > get reported.
 
> Most of the tests in my test-suite are reactive.  Meaning, I wrote them 
> after an ABI-breaking change was reported elsewhere, and I needed a small 
> test case for bisection purposes.  Thus they are good for finding if a 
> corner of the perf ABI re-breaks but they're not great at spotting new 
> breakages.
 
> Writing a complete test suite for something as complicated as the 
> perf-event ABI is impractical.  One thing you can do is require anyone 
> submitting new functionality also provide a regression test, but

Agreed.

> I don't see that happening.

See some of Namhyung, Adrian and Jiri recent patchsets, they came with
'perf test' regression tests.
 
- ARnaldo
