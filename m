Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967774Ab3E3HZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:25:42 -0400
Received: from 6.mo4.mail-out.ovh.net ([188.165.36.253]:55209 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967687Ab3E3HZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:25:35 -0400
Date: Thu, 30 May 2013 09:21:24 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Olof Johansson'" <olof@lixom.net>, linux-fbdev@vger.kernel.org,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [RFC] Add co-maintainer for fbdev
Message-ID: <20130530072124.GD19468@game.jcrosoft.org>
References: <20130524153835.GF15839@game.jcrosoft.org>
 <201305242056.42482.arnd@arndb.de>
 <51A29DB9.7030505@gmx.de>
 <201305282319.30311.arnd@arndb.de>
 <002301ce5c0c$5552b650$fff822f0$@samsung.com>
 <20130529135346.43ebe4c4565d90cec195e38e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529135346.43ebe4c4565d90cec195e38e@linux-foundation.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 18368775507070004212
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrudekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrudekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:53 Wed 29 May     , Andrew Morton wrote:
> On Wed, 29 May 2013 10:32:08 +0900 Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > On Wednesday, May 29, 2013 6:20 AM, Arnd Bergmann wrote:
> > > On Monday 27 May 2013, Florian Tobias Schandinat wrote:
> > > > >> On Fri, May 24, 2013 at 8:38 AM, Jean-Christophe PLAGNIOL-VILLARD
> > > > >> <plagnioj@jcrosoft.com> wrote:
> > > > >>> Hi Florian,
> > > > >>>
> > > > >>>         As you seems very busy I'd like to propose the help you to handle the
> > > > >>>         fbdev subsystem to easier the rich of the fbdev patch to Linus
> > > > >>>
> > > > >>>         As I'm working on fbdev on at91 and others and already Co-Maintain the
> > > > >>>         at91 mach on ARM
> > > > >>>
> > > > >>>         And if you are not willing to continue I could take over
> > > >
> > > > Yeah, it would be great if you could help, at the moment I get barely
> > > > any sleep, let alone that I could keep up with the majority of mail I
> > > > get. I'll let you decide whether you want to be sole maintainer or not.
> > > 
> > > For any bigger subsystems, it's good practice to have two maintainers,
> > > even if one of them does all the work. I think it makes sense to have
> > > Jean-Christophe as the primary maintainer and owner of the git tree,
> > > but it may also be good to have you or Tomi listed as a second maintainer
> > > for times when Jean-Christophe isn't available.
> > 
> > Hi Arnd,
> > 
> > I agree with Arnd's opinion.
> > It looks good to have Florian or Tomi listed as a second maintainer.
> 
> Someone send a patch!


Olof notice on IRC
It was me I use git-send-email but the From was scrued and my name  disapear
in the From

I resend it

Can I have you ack on it?

Best Regards,
J.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
