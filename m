Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3CKOQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:16:41 -0400
Received: from sapphire.tuxdriver.com ([70.61.120.61]:51931 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750923Ab3CKOQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:16:39 -0400
X-Greylist: delayed 1511 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 10:16:39 EDT
Date: Mon, 11 Mar 2013 09:44:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        ath9k_htc_fw@lists.infradead.org, Chris Zankel <chris@zankel.net>,
        linux-kernel@vger.kernel.org, Marc Gauthier <marc@tensilica.com>,
        lwn@lwn.net
Subject: Re: [Announce] open ath9k_htc firmware
Message-ID: <20130311134414.GA13275@tuxdriver.com>
References: <CAB=NE6WwQDfx+H4zV2niLDaZ0vGAahEF5jg1WS+NU7YhTZ9rQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6WwQDfx+H4zV2niLDaZ0vGAahEF5jg1WS+NU7YhTZ9rQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Awesome news!  Many thanks to Adrian, Luis, and all the others they
have credited with helping this along!

John

On Fri, Mar 08, 2013 at 03:46:38PM -0800, Luis R. Rodriguez wrote:
> Many thanks to Adrian for his hard work on all this and to everyone
> else who volunteered to help make this happen, including the
> understanding by our management at QCA and even Tensilica requires
> some handsome applause for their commitment, understanding on letting
> us get this out. We now have a public mailing list for development:
> 
> http://lists.infradead.org/mailman/listinfo/ath9k_htc_fw
> 
> Full steam ahead!
> 
>   Luis
> 
> On Fri, Mar 8, 2013 at 3:32 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> > Hi,
> >
> > I hate fanfare.
> >
> > You can all thank Luis Rodriguez for his ridiculously long and hard
> > fighting to get this stuff pushed through the grinder to make this
> > happen.
> >
> > There's also been a hard working team of developers behind the scene -
> > Felix Fietkau, Eugene Krasnikov, Sujith Manoharan, and the team from
> > Cozybit. They've been working hard to get the codebase converted over
> > to using the open source tensilica toolchain and finding/fixing up any
> > silly issues that may creep up from that.
> >
> > I've just been involved in shepharding this stuff into a sensible
> > shape and pushing it through the final stage (legal review) before
> > publication.
> >
> > You can find it here:
> >
> > https://github.com/qca/open-ath9k-htc-firmware
> >
> > There's a bunch of sorely needed work to do in the short term:
> >
> > * felix has a replacement cmake build system that I'd like to now integrate;
> > * there's lots of build warnings which need to be removed (and then
> > build this thing using -Wall -Werror);
> > * some general code cleanup and documentation wouldn't be rejected -
> > but I don't really want any sweeping code changes to go in until we've
> > tidied up the build warnings and validated that the image(s) work
> > right.
> >
> > I plan on doing some test builds shortly. I plan on bumping the
> > firmware to 1.4 once felix's cmake system is in place and people have
> > validated that this work.s
> >
> > Thanks,
> >
> >
> >
> > Adrian
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
