Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3LPQf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:35:57 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38727 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3LPQfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:35:52 -0500
Date: Mon, 16 Dec 2013 16:35:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: (max8997) Handle the potential error for
 mfd_add_devices
Message-ID: <20131216163546.GR18769@lee--X1>
References: <1387194424-2701-1-git-send-email-lpapp@kde.org>
 <20131216134633.GI18769@lee--X1>
 <CAOMwXhOnHNrzEvf0+QRn6dGb42xR9a33joZcou3ancwSYe36Ug@mail.gmail.com>
 <20131216150937.GO18769@lee--X1>
 <CAOMwXhNJFGiRNB4jnTrzzpSGL8XvaR1Ph_pFrdU+x+guy7Tamg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhNJFGiRNB4jnTrzzpSGL8XvaR1Ph_pFrdU+x+guy7Tamg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a good introduction to the Kernel Community.

Please adapt your attitude or people will stop helping you.

> >> I think you commented on the wrong patch. There has been a newer submitted.
> >
> > No top posting please.
> 
> Tell that to the client I need to use. IMO, making these inline posts
> mandatorily when the reply is a single line makes not much sense.
> Anyway, I will follow the inconvenient way.

If you are not replying to a particular comment, then there is no need
to quote it.

Please read and inwardly digest:
  Documentation/email-clients.txt

> >> > The $SUBJECT line is wrong. To see how a subsystem usually formats
> >> > theirs you must do something like `git log --oneline -- <subsystem>`.
> >> > And duplicate the format.
> >> >
> >> > Commit message?
> >
> > These comments are still relevant, please re-post your patch with the
> > points rectified.
> 
> I really do not understand how they relevant. "Commit message?" ->
> What about it?

The issue is that there isn't one.

> It has a pretty clear commit message.

If you are referencing my comments about the $SUBJECT line, then I
have to disagree with you there. It's actually pretty vague, does not
describe either the issue or what steps you've taken to rectify it.

> Are you now just
> picking nits about "foo:" vs "(foo)" in the short line?

That is also an issue. Did you issue the command I sent you:

  `git log --oneline -- drivers/mfd`

Issue it now and see if _anyone_ has _ever_ used your formatting.

> >> >> +     if (ret < 0) {
> >> >> +             dev_err(dev, "cannot add mfd cells\n");
> >> >> +             goto err_mfd;
> >> >> +     }
> >> >
> >> > Have you tested this patch on h/w? Did you even compile it?
> >
> > You must ensure to test your patches before sending to the MLs, it's
> > the very least we expect.
> 
> I am not sure what point you are trying to make. Feel free to reject
> the patch for this error handling.

I'm not rejecting it because of the error handling, I'm rejecting it
because it hasn't been tested and it doesn't even compile.

> Clearly, the patch has been updated
> due to a previous mistake. I would not make a fuss about an issue
> which had been fixed before getting any comment.

How was this 'clear'? Our inboxes are date/time sequential.

This patch was read _before_ the one you posted _subsequently_.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
