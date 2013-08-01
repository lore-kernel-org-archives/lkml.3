Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3HAQBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:01:06 -0400
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:42658 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755891Ab3HAQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:01:04 -0400
Date: Thu, 1 Aug 2013 12:02:06 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Dave Jones <davej@redhat.com>
cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
In-Reply-To: <20130801025911.GA20166@redhat.com>
Message-ID: <alpine.DEB.2.02.1308011158360.11550@pianoman.cluster.toy>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com> <20130730221435.GA22240@redhat.com> <20130730231120.GC30725@blackmetal.musicnaut.iki.fi> <20130730231533.GA26824@redhat.com> <20130730235834.GD30725@blackmetal.musicnaut.iki.fi>
 <20130731000444.GC1281@redhat.com> <20130731094012.GU24642@n2100.arm.linux.org.uk> <20130731142430.GA4545@redhat.com> <CAOesGMiBa7fT+HZquNrwV=3P=Z-F9c8L7YQr7=D2BO_6pJXQ0w@mail.gmail.com> <20130801025911.GA20166@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020206.51FA8640.004F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013, Dave Jones wrote:

> On Wed, Jul 31, 2013 at 07:47:30PM -0700, Olof Johansson wrote:
>  > How long would a useful run of trinity take?
> 
> It blew up in a minute or so of runtime when I tried last week.

I also have a chromebook running 3.4 and it is trivially easy to crash it 
with some simple perf_event tests I have (not the fuzzer, but just the 
regular validation tests that test counter overflow).

Like Dave, I didn't bother reporting the problem because I figured 3.4 was 
too old for anyone to care about and it was a struggle getting any 
distro/kernel installed at all on the system let alone trying to boot 
something close to current mainline on it.

Vince
