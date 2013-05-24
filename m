Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab3EXS4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 14:56:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3EXS4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 14:56:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [RFC] Add co-maintainer for fbdev
Date: Fri, 24 May 2013 20:56:42 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <20130524153835.GF15839@game.jcrosoft.org> <CAOesGMj26_=6eQk+=0MPCoobymqrHPwwtiUnv63hz0a9Ou_VMw@mail.gmail.com>
In-Reply-To: <CAOesGMj26_=6eQk+=0MPCoobymqrHPwwtiUnv63hz0a9Ou_VMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305242056.42482.arnd@arndb.de>
X-Provags-ID: V02:K0:fQV2n5pa3/5YGrUDLXqdM7YV/Qkh2GkUg9luq/CFg1z
 Iq2S+qe4PXvJ2CuxjewlLiwE4lKSQuXN8fAIFD+XdXW1lZIXzg
 0kpQwp5IaGJDEn6UBuMH6K6c2v/roGnws3c+HEA2l3nT7Tx6K8
 WUXJsPkwDvTh+c69Lb7/PcdF7oToVYbEmsiXJ9GrzRs4bRV8k3
 7eVU0tHDX2uEFBoWv3v1FmKZuqeGIDwl5xNLxzPjqgHGZfwQWc
 G8GFCim9quiy/n5vuQl2pnhCX7lHub2qVAH7JVvM7qmtajv/9t
 9d41m/8iIQzyI1kK4E+yBUloLwIWDPe0lfFGBCne4ScpcQjEUp
 LhBJfFx+RDUVBT0aWFnI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 May 2013, Olof Johansson wrote:
> [+akpm]

[+florian]

> On Fri, May 24, 2013 at 8:38 AM, Jean-Christophe PLAGNIOL-VILLARD
> <plagnioj@jcrosoft.com> wrote:
> > Hi Florian,
> >
> >         As you seems very busy I'd like to propose the help you to handle the
> >         fbdev subsystem to easier the rich of the fbdev patch to Linus
> >
> >         As I'm working on fbdev on at91 and others and already Co-Maintain the
> >         at91 mach on ARM
> >
> >         And if you are not willing to continue I could take over
> 
> Andrew has been fallback fbdev maintainer for a while, we have the
> option of formalizing that as well. Adding him on cc so he sees this.

It seems that Florian himself was missing on Cc too, probably by accident.

I would certainly welcome Jean-Christophe to step in for fbdev, since I
frequently have trivial patches for the subsystem, either from myself
or one of the subarch maintainers, and it would be helpful to get feedback
on them in order to merge them through arm-soc when they depend on other
patches we carry, or to have them picked up into a git tree.

	Arnd
