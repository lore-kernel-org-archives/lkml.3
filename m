Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab3EXReX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:34:23 -0400
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:55704 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755873Ab3EXReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:34:22 -0400
Date: Fri, 24 May 2013 19:30:08 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Olof Johansson <olof@lixom.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        b.brezillon@overkiz.com,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [GIT PULL] at91: fixes for 3.10 #2
Message-ID: <20130524173008.GJ24476@game.jcrosoft.org>
References: <1369410151-7837-1-git-send-email-nicolas.ferre@atmel.com>
 <CAOesGMjvKhVKZf9A70K7VzXikY902KVyKR==4ivnb-gxhyRCPQ@mail.gmail.com>
 <20130524171709.GH24476@game.jcrosoft.org>
 <CAOesGMjOaWardKRq-8BM_v8JKx+-Vgzg6XRRL5E1FQTut_ePdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMjOaWardKRq-8BM_v8JKx+-Vgzg6XRRL5E1FQTut_ePdQ@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11861074044479580975
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:25 Fri 24 May     , Olof Johansson wrote:
> On Fri, May 24, 2013 at 10:17 AM, Jean-Christophe PLAGNIOL-VILLARD
> <plagnioj@jcrosoft.com> wrote:
> > On 10:11 Fri 24 May     , Olof Johansson wrote:
> >> Hi,
> >>
> >> I'll pull this for now, but...
> >>
> >>
> >> > Jean-Christophe PLAGNIOL-VILLARD (1):
> >> >       ARM: at91: at91sam9n12: move external irq declatation to DT
> >>
> >> This one is not a fix. While OK this time, please stick to only
> >> sending true fixes for 3.10 from here on out.
> >
> > it's as you must specify them via DT, the C code is not event use in case of
> > DT
> > I should have put fix in the commit
> >
> 
> I don't understand.

for DT SoC you must use dt to descrive the external irq on at91 now
the sam9n12 (dt-only soc) was not converted when we did it

this commit fix it

Best Regards,
J.
