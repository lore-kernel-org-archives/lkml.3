Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbaHEJOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:14:49 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:40997 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbaHEJOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:14:46 -0400
Date: Tue, 5 Aug 2014 11:14:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic
 {read,write}s*()
Message-ID: <20140805091426.GA28220@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <43703371.jktNRIezc3@wuerfel>
 <20140719084152.GA31564@ravnborg.org>
 <4967546.K5Yf5hcJE1@wuerfel>
 <20140719091156.GA31772@ravnborg.org>
 <CAMuHMdUUSMGghDVDpdQygQCv0OWGP-Lwxzy004xRpR6BsZS81A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUUSMGghDVDpdQygQCv0OWGP-Lwxzy004xRpR6BsZS81A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > So xxx_p is for pause (or something like that).
> > This also matches that m68k do some tricks with delay() in the _p variants.
> > Thanks for the explanation.
> 
> m68k's isa_delay() uses the same approach as x86's slow_down_io(),
> but only for Q40/Q60, which has a "real" ISA bus that accepts legacy
> ISA expansion cards (http://www.q40.de/).
Based on the nice description from James I have on my todo list
to cook up a patch to io.h to document this.
Had just not got around to do it yet.

	Sam
