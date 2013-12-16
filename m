Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3LPRnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:43:12 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48936 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3LPRnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:43:10 -0500
Date: Mon, 16 Dec 2013 17:43:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: (max8997) Handle the potential error for
 mfd_add_devices
Message-ID: <20131216174304.GA4833@lee--X1>
References: <1387194424-2701-1-git-send-email-lpapp@kde.org>
 <20131216134633.GI18769@lee--X1>
 <CAOMwXhOnHNrzEvf0+QRn6dGb42xR9a33joZcou3ancwSYe36Ug@mail.gmail.com>
 <20131216150937.GO18769@lee--X1>
 <CAOMwXhNJFGiRNB4jnTrzzpSGL8XvaR1Ph_pFrdU+x+guy7Tamg@mail.gmail.com>
 <20131216163546.GR18769@lee--X1>
 <CAOMwXhNXctcQWMU5vKKW52sQ-Ek3Mw3FZLTNJa4GD5qk4O79Gw@mail.gmail.com>
 <20131216170200.GT18769@lee--X1>
 <CAOMwXhMMCFdpZbtuy8n8Xe5hSEBD=6=3mfCp29hRYtULRF6qng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhMMCFdpZbtuy8n8Xe5hSEBD=6=3mfCp29hRYtULRF6qng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is that bad? Cannot you just reply to the "top-post" sentence with
> dropping all the quotes below if that is what you wish?

Yes, only quote what you're replying to and quote _below_.

> >> > Please read and inwardly digest:
> >> >   Documentation/email-clients.txt
> >>
> >> I have read that, however I still have certain restrictions here which
> >> are over the kernel community rules.  That should not block a useful
> >> contribution in my opinion.
> >
> > Your email client does not prevent you from replying inline, which
> > you've proven by this email. Please abide by the rules if you're going
> > to contribute.
> 
> Yes, I can spend more effort with it inconveniently,

Great, thanks.

<snip>

> > Please read:
> >   Documentation/SubmittingPatches
> >
> > Specifically No2.
> 
> I had read that, but as written, I am not sure what more you want to
> add. Should I replicate the title in the body, pretty much? Please be
> specific, and write what you would like to see in the body. I will
> copy/paste it. Currently, I am not sure.

A good commit for your patch might look like this:

  mfd: max8997: Enforce mfd_add_devices() return value check

  The original author provided a random return value check which is
  redundant and seemingly floating. This patch not only relocates
  the check so it is more clearly associated with the invokation of
  mfd_add_devices(), but provides a store for the error value. We
  also print a meaningful message on error before returning.

> > It's not my responsibility to fixup your patches for you. It's your
> > job to ensure they are correct on submission. I am happy to review
> > them for you and provide you with my comments, which I have done.
> >
> > Either fix them up and re-submit or don't. It's no skin off my nose.
> 
> Well, maintainers do it from time to time they apply changes when it
> only needs a minor nitpick modification like this in the commit
> message, but it is no problem. I am fine the linux kernel not having
> this error check, at least for now. :-)

It's better that you do it yourself. If I fixed up everything that was
sent to me incorrect a) I'd have no time left and b) they'd never learn.

This is about teaching a man to fish. 

> > The $SUBJECT line does not conform to what's expected of MFD commits.
> > The $SUBJECT line is vague and you are missing a commit body.
> 
> As written, I am lost what I would need to add to the commit message.
> Please advise, and I will copy and paste that before resending.
> 
> > Why have you removed this line?
> 
> That is just noise. It is better not to remove it, thanks.
> 
> > We're adding devices here, not cells.
> >  "failed to add devices"
> 
> That description is not chosen by me. Actually, that is coming from
> the other mfd drivers, particularly from the other existing MAXIM mfd
> driver. I would not personally break the consistency there.

Please reply to the patch in question, or else things could get
confusing.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
