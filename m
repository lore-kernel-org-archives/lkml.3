Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab3E0Om1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:42:27 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:45446 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932865Ab3E0OmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:42:23 -0400
Date: Mon, 27 May 2013 16:38:11 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-fbdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [RFC] Add co-maintainer for fbdev
Message-ID: <20130527143811.GB23825@game.jcrosoft.org>
References: <20130524153835.GF15839@game.jcrosoft.org>
 <CAOesGMj26_=6eQk+=0MPCoobymqrHPwwtiUnv63hz0a9Ou_VMw@mail.gmail.com>
 <201305242056.42482.arnd@arndb.de>
 <51A29DB9.7030505@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A29DB9.7030505@gmx.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8127871427697486764
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedruddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedruddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:41 Sun 26 May     , Florian Tobias Schandinat wrote:
> Hi Jean-Christophe,
> 
> On 05/24/2013 06:56 PM, Arnd Bergmann wrote:
> > On Friday 24 May 2013, Olof Johansson wrote:
> >> [+akpm]
> > 
> > [+florian]
> 
> Thanks for CC'ing me. Lately I got dropped frequently from the
> mailinglist (after 1 or 2 days). Guess I should try subscribing via my
> own mail server.
> 
> >> On Fri, May 24, 2013 at 8:38 AM, Jean-Christophe PLAGNIOL-VILLARD
> >> <plagnioj@jcrosoft.com> wrote:
> >>> Hi Florian,
> >>>
> >>>         As you seems very busy I'd like to propose the help you to handle the
> >>>         fbdev subsystem to easier the rich of the fbdev patch to Linus
> >>>
> >>>         As I'm working on fbdev on at91 and others and already Co-Maintain the
> >>>         at91 mach on ARM
> >>>
> >>>         And if you are not willing to continue I could take over
> 
> Yeah, it would be great if you could help, at the moment I get barely
> any sleep, let alone that I could keep up with the majority of mail I
> get. I'll let you decide whether you want to be sole maintainer or not.

I'd like to have feed back from others on this

> I still have interest in the subsystem, but it looks like VIA won't
> provide any information for their new VX11 chipset IGP for any open
> source driver and I'm still looking for a small, quiet mobile device as
> a replacement for my precious netbook that broke down last autumn to
> allow me working when I'm not at home.

I personnaly use a MacBook Air 11" with a powerpack to extend it to 15h of
battery
> 
> >> Andrew has been fallback fbdev maintainer for a while, we have the
> >> option of formalizing that as well. Adding him on cc so he sees this.
> 
> At this point I'd like to thank all people who have helped out so far,
> especially Tomi and Andrew.
> 
> 
> Best regards,
> 
> Florian Tobias Schandinat
