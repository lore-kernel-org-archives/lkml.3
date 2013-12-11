Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3LKMbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:31:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55720 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3LKMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:31:40 -0500
Date: Wed, 11 Dec 2013 09:31:17 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] tools/: Convert to new topic libraries
Message-ID: <20131211123117.GQ8098@ghostprotocols.net>
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
 <1386605664-24041-2-git-send-email-bp@alien8.de>
 <87zjo9jxs5.fsf@sejong.aot.lge.com>
 <20131210112758.GA31437@pd.tnic>
 <87iouwi3ng.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iouwi3ng.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 10:21:07AM +0900, Namhyung Kim escreveu:
> On Tue, 10 Dec 2013 12:27:59 +0100, Borislav Petkov wrote:
> > On Tue, Dec 10, 2013 at 10:32:42AM +0900, Namhyung Kim wrote:
> >> I'm sorry to raise a naming issue again. But why the lib has 'k' and
> >> the directory doesn't? Isn't it more natural to prepend 'k' to 'api'
> >> as the name "api" looks too general?

> >>   - libkapifs.{a,so} /kapi/fs/fs.c

> >> (Please ignore if it's already discussed..)

> > Hmm, no, it hasn't been discussed but I assumed tools/lib/api/ being in
> > the *kernel* repository implicitly says which api functionality we're
> > collecting there. One of the main reasons to have tools/ in the kernel
> > AFAIU is to have those tools which are using its API close. Therefore,
> > tools/lib/api/ should be unambiguous.

> > libkapifs.a (and the .so version even more, for that matter, and if we
> > decide to do it one day) would probably need more distinction and the
> > "k" in "kapi" there makes more sense.

> > This is at least how I see it from here.

> Yeah I assumed you guys plan to export it to the wild. :)

> I'm OK with tools/lib/api if it lives and used only in the kernel tree.

This is the idea, no commitment to use outside tools/ living code at
this point.

Anybody can try and provide comments on his mileage, but we're still at
a too early stage for any kind of commitments.

But yeah, everybody, I think, agrees that the ball needs to keep on
rolling on the direction of avoiding code duplication for tools/ living
code.

Back to Namhyung's suggestion, yeah, tools/lib/kapi/ would consume just
one more letter and would further disambiguate things.

But this can be done later if Borislav is unconvinced at this point.

- Arnaldo
