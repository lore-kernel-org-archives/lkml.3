Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbbA0OVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:21:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39475 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758182AbbA0OVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:21:33 -0500
Date: Tue, 27 Jan 2015 15:21:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Richard Weinberger <richard@nod.at>, linux-mmc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
Message-ID: <20150127142120.GA3351@pd.tnic>
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
 <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
 <54C77E69.7050600@ahsoftware.de>
 <20150127120855.GA9254@pd.tnic>
 <54C7816A.8050800@ahsoftware.de>
 <54C78524.3070901@nod.at>
 <54C7881F.6020501@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C7881F.6020501@ahsoftware.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 01:44:15PM +0100, Alexander Holler wrote:
> Yes. Sorry, but I had so many bad experiences with maintainers.

Well, I can't comment on your experience for the simple reason that I
haven't followed those discussions. In their defence, though, you have
to know that those people get to review your code, apply it and then
deal with it long after you've gone on about doing other things.

So, even if you don't always agree with them, you need to realize that
those are the people responsible for that code and if they request a
reasonable change in your submission, you have to do it. It is that
simple.

 [ Unless you have a good argument against it but that's a different
   story and this is what is called the "review" process. ]

But this is how basically linux kernel development is done. It is not
about simply doing something but about doing it right. And as long as
you get *reasonable* change requests for your patch, you go and change
it.

And yes, not only *you* but *we* all have to redo our patches. And it
is not unheard of people working on a single feature for months if not
years, doing changes, doing changes again, testing variants and so on
and so on. Simply reading lkml would give you lots of examples.

And yet we still do it because it is simply great fun and one gets to
learn tons of new things when working with the community (don't listen
to all that bullshit about the kernel community being unfriendly - the
real problem there is most of the time somewhere else).

But instead of having fun, you're frustrated. And people should not be
frustrated because that is generally bad for their health. So maybe you
should sit down, take a quiet minute and think about what you actually
want to do. And if kernel development doesn't give you any fun, then
you're probably on the right track with not wanting to do it anymore.

If it were me, I'd stop doing it too if it is not fun anymore - life's
too short to be frustrated and not have fun. It is cheesy but it is
true.

I sincerely hope that helps in any way.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
