Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab3E2Aik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:38:40 -0400
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:32845 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933378Ab3E2Aii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:38:38 -0400
Date: Wed, 29 May 2013 02:34:28 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Olof Johansson <olof@lixom.net>, linux-fbdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC] Add co-maintainer for fbdev
Message-ID: <20130529003428.GB23899@game.jcrosoft.org>
References: <20130524153835.GF15839@game.jcrosoft.org>
 <201305242056.42482.arnd@arndb.de>
 <51A29DB9.7030505@gmx.de>
 <201305282319.30311.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305282319.30311.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5623588560505711364
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrudehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrudehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:19 Tue 28 May     , Arnd Bergmann wrote:
> On Monday 27 May 2013, Florian Tobias Schandinat wrote:
> > >> On Fri, May 24, 2013 at 8:38 AM, Jean-Christophe PLAGNIOL-VILLARD
> > >> <plagnioj@jcrosoft.com> wrote:
> > >>> Hi Florian,
> > >>>
> > >>>         As you seems very busy I'd like to propose the help you to handle the
> > >>>         fbdev subsystem to easier the rich of the fbdev patch to Linus
> > >>>
> > >>>         As I'm working on fbdev on at91 and others and already Co-Maintain the
> > >>>         at91 mach on ARM
> > >>>
> > >>>         And if you are not willing to continue I could take over
> > 
> > Yeah, it would be great if you could help, at the moment I get barely
> > any sleep, let alone that I could keep up with the majority of mail I
> > get. I'll let you decide whether you want to be sole maintainer or not.
> 
> For any bigger subsystems, it's good practice to have two maintainers,
> even if one of them does all the work. I think it makes sense to have
> Jean-Christophe as the primary maintainer and owner of the git tree,
> but it may also be good to have you or Tomi listed as a second maintainer
> for times when Jean-Christophe isn't available.

I agree with Arnd

As example I'll be mostly off first week of June.


Tomi Florian what do you think

I plan to send the patch + PULL to Linus end of this week before I work-off

For the record the new git tree is here

git://git.kernel.org/pub/scm/linux/kernel/git/plagnioj/linux-fbdev.git

Best Regrds,
J.
