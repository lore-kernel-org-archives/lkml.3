Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3C0U7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:59:25 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:44509 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3C0U7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:59:24 -0400
Date: Wed, 27 Mar 2013 17:59:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf sort: Add 'addr' sort key
Message-ID: <20130327205917.GA2027@ghostprotocols.net>
References: <1364299918-31175-1-git-send-email-namhyung@kernel.org>
 <20130326144023.GA1621@gmail.com>
 <87ehf1gylp.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehf1gylp.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 27, 2013 at 03:12:34PM +0900, Namhyung Kim escreveu:
> On Tue, 26 Mar 2013 15:40:23 +0100, Ingo Molnar wrote:
> > * Namhyung Kim <namhyung@kernel.org> wrote:
> >> New addr sort key provides a way to sort the entries by the symbol
> >> addresses.

> > No objections from me - just wondering about the motivation: why would we 
> > want to sort by symbol address?
 
> In fact, it came from bugzilla:
 
>   https://bugzilla.kernel.org/show_bug.cgi?id=55561

Will Cohen asked if this was possible while trying to figure out why
some libxul.so samples were not being resolved to symbols, Will?

Namhyung, I'm using:

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=55561

Just before the: Link: entry, consider adding it when addressing some
bugzilla entry, be it from bugzilla.kernel.org or from some other
bugzilla where problems or feature requests were made.

- Arnaldo
 
> >
> > Perhaps to see the overhead layout/distribution within a DSO, to better 
> > cache-pack hot functions by placing them next to each other?
> >
> > Putting a short usecase into the changelog (or even better, the 
> > documentation) would be nice.
> 
> Well, I didn't thought it much, but yeah, aforementioned usecase looks
> promising.  Also it might be useful to find out which part is the
> hotpath in a function if you have some really big functions (possibly
> due to auto-inlining or something).
> 
> Arnaldo, do you have other usecase/scenario in mind?

See above.
