Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaIXKkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:40:52 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:64486 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIXKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:40:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
Date: Wed, 24 Sep 2014 12:40:42 +0200
Message-ID: <12538756.JybTPMqFHj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ582-Bb2=s+AGsAeTHJMwBkUCUEoEbP770MJgTDkvev0yg@mail.gmail.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com> <13000968.l0laEvMsix@wuerfel> <CAFiDJ582-Bb2=s+AGsAeTHJMwBkUCUEoEbP770MJgTDkvev0yg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1cxThobTC4aNt6JEppEUZT6PIlIuPmwWUfxTX8U63AP
 jVA1qzvf1M5ADfnHOs8qcmb+j/CzSbyJooSGGEBTUitJOgGjgt
 35OTzWAlrBdkOLGmzqJ+a+nAhSw3Vlb9iLbBERu1xxjGZcRMOu
 j6ZtrdO9e2uGs6sNdRCvk7dFoVXpzmnnKwf6hkHWSs0Rup4Eyj
 Js951YWOEcumfQNpn6JN5wrq52sJQxiJRaj9CMfGwcGRdgc6Ml
 Ues1Sl582+8Q+cYTyPc9HFvXnKIH/1HJStioKp1cpYsBtFDS+o
 bFvPnQbss+AZzdl6ekjYv6S1fdOVJHVqy1scTLBMtzVqfXhxE1
 5Hve2HLdDbDBpQHp3w08=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 18:18:50 Ley Foon Tan wrote:
> On Tue, Sep 23, 2014 at 6:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 23 September 2014 18:20:08 LF.Tan wrote:
> >> Hi Arnd
> >>
> >> Are you okay with this generic futex in asm-generic?
> >>
> >
> > Yes, this looks good. Remind me again who need this, would it make
> > sense to merge this through an architecture-specific tree for
> > whichever architecture can benefit from it?
> What is the common practice for this?
> Do you mean merge with nios2 or other arch, eg m68k?

I mean do it as part of the nios2 patches.

	Arnd
