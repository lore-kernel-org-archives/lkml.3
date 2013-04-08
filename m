Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935514Ab3DHMDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:03:22 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:35614 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935473Ab3DHMDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:03:20 -0400
Date: Mon, 8 Apr 2013 13:52:38 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Olof Johansson <olof@lixom.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [GIT PULL] at91: DT changes for 3.10 #2
Message-ID: <20130408115238.GY20693@game.jcrosoft.org>
References: <1364569179-24773-1-git-send-email-nicolas.ferre@atmel.com>
 <20130402184947.GA8015@quad.lixom.net>
 <515BDE2C.9030904@atmel.com>
 <515D49D4.5020208@atmel.com>
 <CAOesGMiDEER3++J80KtU3UDLWNADaJhGS7upArFm2RzM4Z_P=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMiDEER3++J80KtU3UDLWNADaJhGS7upArFm2RzM4Z_P=w@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12684106877266340655
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrleelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrleelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:19 Thu 04 Apr     , Olof Johansson wrote:
> On Thu, Apr 4, 2013 at 2:37 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > On 04/03/2013 09:45 AM, Nicolas Ferre :
> >> On 04/02/2013 08:49 PM, Olof Johansson :
> >>> On Fri, Mar 29, 2013 at 03:59:39PM +0100, Nicolas Ferre wrote:
> >>>> Arnd, Olof,
> >>>>
> >>>> Here is a pull-request for AT91 that is dedicated to Device Tree
> >>>> modifications. It is stacked on the material that you already have
> >>>> for 3.10 in your arm-soc/at91/dt branch.
> >>>> Following our discussion with Arnd, I added the non-urgent patches that I
> >>>> already proposed too late for 3.9. I also included the moving of macb node
> >>>> and kept the original patch.
> >>>>
> >>>> Thanks, best regards,
> >>>>
> >>>> The following changes since commit 6901d947be5ba1245a0f63271355b95f9056a362:
> >>>>
> >>>>   ARM: at91/at91sam9x5cm: add 1-wire chip on CM board (2013-03-21 16:07:15 +0100)
> >>>>
> >>>> are available in the git repository at:
> >>>>
> >>>>   git://github.com/at91linux/linux-at91.git tags/at91-dt
> >>>>
> >>>> for you to fetch changes up to cc2e191b0ccc5a987fdb29261ab9c264c608924d:
> >>>>
> >>>>   ARM: at91/dt: fix macb node declaration (2013-03-29 10:02:04 +0100)
> >>>>
> >>>> ----------------------------------------------------------------
> >>>> One macb DT node move for 9x5 family: 9g15 doesn't
> >>>> have an Ethernet interface.
> >>>> Little fixes mainly related to at91sam9x5 DT and the
> >>>> RTC addition.
> >>>> Addition of the Acme Systems Aria G25 board.
> >>>>
> >>>> ----------------------------------------------------------------
> >>>> Douglas Gilbert (1):
> >>>>       ARM: at91: add Acme Systems Aria G25 board
> >>>
> >>> Hi,
> >>>
> >>> I just replied to the above patch -- please prefix the dts files with the
> >>> platform so it's easier to navigate the directory.
> >
> > I do not want to spark a debate here, but moving to directories per
> > "mach" earlier would have made things easier. If I recall well,
> > Jean-Christophe has proposed it a long time ago...
> 
> Yeah, we're at a size where it's starting to be warranted (powerpc
> does so already). It does cut down on the cross-exposure and review
> though and puts everyone in their own little sandbox, so there's some
> benefit in keeping it flat.
> 
> I think that benefit is losing its appeal though. But let's hold off
> for another couple of releases with the churn of moving things out in
> subdirectories.
> 
> >> Yes, I have to make sure that everybody agree on our side...
> >
> > The difficult point with this prefix... well it is difficult to tell...
> > our product will never be called "at91" again!
> 
> That's a marketing issue, not a technical kernel one. If we create
> subdirectory it makes sense to name it 'atmel' instead of 'at91'
> though, I'm sure.
> 
> > So, yes, our Linux identity is still "at91" and we are pretty attached
> > to it but our newer products are named "sam" + "core" + "product family"
> > which results in our newer family: "sama5d3" (note the at91 is missing)...
> > => anyway, we think that the at91 prefix is still vivid in Linux
> > community and we consider it as a good choice for now.
> > So, I may rename the newly introduced "sama5d3*.dts[i]" files with
> > "at91-sama5d3*.dts[i]" (while .c/.h files will remain the same).
> 
> Sounds reasonable, or stick to the same format as you already have
> with at91sam9 families. When we move to subdirectories it might make
> sense to stick them under 'atmel' instead of 'at91' though and drop
> the prefix.
I've a rfc for this as I do no lihe idea of prefix

and it make the grep search mo complex

I send a patch to clean the '\\' stuff in this Makefile

can you take

I send the dir split on the top of this
> 
> 
> 
> -Olof
