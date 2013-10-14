Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3JNOEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:04:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51166 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab3JNOEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:04:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
Date: Mon, 14 Oct 2013 16:16:37 +0200
Message-ID: <2968661.r8dg85ocZF@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAMP44s1hVCk=vkAmYoQA85U1sTQ-JCLmWi0kDejfY8m=sXQdpQ@mail.gmail.com>
References: <1380820383-23336-1-git-send-email-felipe.contreras@gmail.com> <1905683.dBVjOILnXT@vostro.rjw.lan> <CAMP44s1hVCk=vkAmYoQA85U1sTQ-JCLmWi0kDejfY8m=sXQdpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 14, 2013 08:14:28 AM Felipe Contreras wrote:
> On Mon, Oct 14, 2013 at 6:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, October 13, 2013 10:30:50 PM Felipe Contreras wrote:
> >> On Thu, Oct 3, 2013 at 12:13 PM, Felipe Contreras
> >> <felipe.contreras@gmail.com> wrote:
> >> > More people have reported they need this for their machines to work
> >> > correctly.
> >> >
> >> > https://bugzilla.kernel.org/show_bug.cgi?id=60682
> >>
> >> I see this was merged to the linux-next branch. Is there any reason
> >> why it's not proposed for v3.12?
> >
> > It is not a fix for a recent breakage, it doesn't fix an outright crash or
> > security issue and there is a chance, albeit arguably very small, that
> > something will not function on one of the affected systems for someone
> > as a result of the blacklisting.
> 
> So? That chance is already there because the blacklist is already
> there, but we cannot know until v3.12 is released, because that's when
> most people would be testing that code.
> 
> It seems to me your worry is that somebody would report a regression
> that happened v3.12-rc6 (if it has this patch applied), while it
> worked correctly in v3.12-rc5, in which case you would get a complaint
> from Linus.
> 
> But we all know that's not going to happen. The complaints (if any)
> would arrive in v3.12, and that would happen regardless of this patch.
> 
> Besides, our goal is to make v3.12 as stable as possible, and it seems
> to me you are blindly following the letter of a rule, instead if
> interpreting what is the intent of rule. If I had sent the patch the
> 29th of June, it would have been aplied by now and be part of the
> current blacklist, and the result would be the same; we cannot really
> know until v3.12 is released.

Oh, please give me a break.

I've applied your patch even though I really should have waited for an ACK from
Matthew before doing that, but that only made you *more* demanding.

I generally tend to be nice to people, but you evidently take that as a sign of
weakness, so trying to be nice to you doesn't really make sense to me.  On the
other hand, I'm not too good at throwing flames at people and it distracts me
so much that I can't really afford it.  Please find yourself someone else to
fight with.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
