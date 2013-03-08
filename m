Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab3CHXrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:47:02 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57690 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3CHXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:47:00 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 8 Mar 2013 15:46:38 -0800
X-Google-Sender-Auth: JQID2xYslz4k4aJ6qhYPZLWlVGE
Message-ID: <CAB=NE6WwQDfx+H4zV2niLDaZ0vGAahEF5jg1WS+NU7YhTZ9rQw@mail.gmail.com>
Subject: Re: [Announce] open ath9k_htc firmware
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        ath9k_htc_fw@lists.infradead.org, Chris Zankel <chris@zankel.net>,
        linux-kernel@vger.kernel.org, Marc Gauthier <marc@tensilica.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks to Adrian for his hard work on all this and to everyone
else who volunteered to help make this happen, including the
understanding by our management at QCA and even Tensilica requires
some handsome applause for their commitment, understanding on letting
us get this out. We now have a public mailing list for development:

http://lists.infradead.org/mailman/listinfo/ath9k_htc_fw

Full steam ahead!

  Luis

On Fri, Mar 8, 2013 at 3:32 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> I hate fanfare.
>
> You can all thank Luis Rodriguez for his ridiculously long and hard
> fighting to get this stuff pushed through the grinder to make this
> happen.
>
> There's also been a hard working team of developers behind the scene -
> Felix Fietkau, Eugene Krasnikov, Sujith Manoharan, and the team from
> Cozybit. They've been working hard to get the codebase converted over
> to using the open source tensilica toolchain and finding/fixing up any
> silly issues that may creep up from that.
>
> I've just been involved in shepharding this stuff into a sensible
> shape and pushing it through the final stage (legal review) before
> publication.
>
> You can find it here:
>
> https://github.com/qca/open-ath9k-htc-firmware
>
> There's a bunch of sorely needed work to do in the short term:
>
> * felix has a replacement cmake build system that I'd like to now integrate;
> * there's lots of build warnings which need to be removed (and then
> build this thing using -Wall -Werror);
> * some general code cleanup and documentation wouldn't be rejected -
> but I don't really want any sweeping code changes to go in until we've
> tidied up the build warnings and validated that the image(s) work
> right.
>
> I plan on doing some test builds shortly. I plan on bumping the
> firmware to 1.4 once felix's cmake system is in place and people have
> validated that this work.s
>
> Thanks,
>
>
>
> Adrian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
