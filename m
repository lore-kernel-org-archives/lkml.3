Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3CUAKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:10:17 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:58414 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3CUAKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:10:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130321104747.b34175b397b5b16d61040fae@canb.auug.org.au>
References: <CAAVeFuLjqFoOyqoWWT9fKjs6AB5DU9nT5p+nJ5uhaaUeh4_MXg@mail.gmail.com>
 <20130321104747.b34175b397b5b16d61040fae@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 21 Mar 2013 00:09:53 +0000
X-Google-Sender-Auth: DNmKEXqpxLIjFTEgVn8Te2h-9jk
Message-ID: <CACxGe6tXes_ecPsnEnc+MB7K0Zi8wWV6T5=AUyAuDUBEQ-4rSA@mail.gmail.com>
Subject: Re: New tree for linux-next
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexandre Courbot <gnurou@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Alexandre,
>
> On Wed, 20 Mar 2013 23:02:14 +0900 Alexandre Courbot <gnurou@gmail.com> wrote:
>>
>> I am currently trying to get rid of the GENERIC_GPIO config option in
>> order to center GPIO support around gpiolib. The patch series has been
>> rather welcome and I collected a few acks, but since the change is
>> rather intrusive and affects a lot of of architectures, it has been
>> suggested that I submit it as a separate branch on linux-next to see
>> how it (mis)behaves (full discussion is visible at
>> https://lkml.org/lkml/2013/3/13/74 ).
>
> OK, that seems sensible.
>
>> So I have set up a branch on github on
>> git://github.com/Gnurou/linux.git , for_next branch. Could you include
>> it in linux-next to see if people start complaining about broken
>> builds? I also actually have a couple questions about the submission
>> process:
>
> Added from today.  I have called it gen-gpio and you are the only listed
> contact (in case I have problems with it).
>
>> - My branch is based on the latest stable, similarly to what I have
>> seen elsewhere. One of the patches triggers a merge conflict on
>> today's linux-next due to a whitespace change. Is there something I
>> can do to fix this?
>
> Do not worry about merge conflicts, that is my and Linus' job.

Latest stable? As in based on one of the linux-stable point releases
(That Greg does) or based on Linus' tree? It must be based on Linus'
tree to be mergable into mainline.

>
>> - By the meantime, another person has submited a new patch that
>> re-uses the option I am trying to remove. Is there a way for me to
>> base on given next release to fix this as well? Or should I contact
>> that person to ask him not to use this option anymore?
>
> The latter.  Also if you could supply me (and them) with any hints on how
> to cope with the merge problem, that would help.
>
> One point:  if this branch is meant to be merged by others, it *must not*
> be rebased or rewritten, it can only be appended to.

Eventually I will want to pull this into my gpio-next tree, but I'll
give it a bit to see how it shakes out. Regardless I'll let you know
when I want to do so and so you'll know when it can no longer be
rebased.

g.
