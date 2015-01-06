Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbbAFOHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:07:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbAFOHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:07:06 -0500
Date: Tue, 6 Jan 2015 15:06:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/30] perf tools: Add new build framework support
Message-ID: <20150106140618.GB25004@krava.brq.redhat.com>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-2-git-send-email-jolsa@kernel.org>
 <20150105105751.GB19655@pd.tnic>
 <20150105111335.GB21260@krava.brq.redhat.com>
 <20150106134108.GB2517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106134108.GB2517@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:41:08AM -0200, Arnaldo Carvalho de Melo wrote:

SNIP

> > the reason for this switch is to have a first step towards
> > easy config support 'kernel Kconfig style like' in build
> > 
> > also with this change it's easier to see how the perf binary
> > is build and what flags were used for particular object..
> > at least for kernel developer used to kbuild ;-)
> > 
> > I also believe that the support to allow just part of the perf
> > code in perf binary will force the less spaghetti code ;-)
> 
> Right, making it possible for us to build a minimalistic perf will have
> manifold good implications :-)
> 
> But perhaps we could continue calling it the same way as in the kernel?
> I.e. we would then be using the "Kbuild" build configuration mechanism,
> the K would be there just for historic reasons.

well, the main reason I used 'Build' instead of 'KBuild' was to
'say' that this is not Kbuild makefile.. because it's not ;-)

It's separated build framework with no dependency on KBuild
makefiles. I think the 'KBuild' name could mislead folks when
hunting things in perf build.

jirka
