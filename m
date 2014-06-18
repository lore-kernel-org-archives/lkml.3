Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaFRFce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:32:34 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:54624 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaFRFcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:32:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140617220017.GA17864@qualcomm.com>
References: <1402424723-9659-1-git-send-email-bjorn.andersson@sonymobile.com>
	<20140617220017.GA17864@qualcomm.com>
Date: Tue, 17 Jun 2014 22:32:32 -0700
Message-ID: <CAJAp7OhRSHjq7hyTVbWcoq_OfnFbZ7Ud=uWzfsSNku7Zqm4x6w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add msm8960 definitions
From: Bjorn Andersson <bjorn@kryo.se>
To: Andy Gross <agross@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 3:00 PM, Andy Gross <agross@codeaurora.org> wrote:
> On Tue, Jun 10, 2014 at 11:25:23AM -0700, Bjorn Andersson wrote:
>
> In general, it all looks good.  I only have 2 areas of concern.  The first is a
> nit and it has to do with alternate pins for functions.  There really isn't a
> need for a separate function name.  That would only be required if the same pin
> had multiple functions defined for the same thing.
>

I have to blame unclear documentation here ;)
Will drop all the _[abc] suffixes.

> As for the second area of concern, there are some discrepancies between our
> internal function map and yours.  This is probably due to some minor difference
> in chip rev.  I'll try to find more information on this and determine if that is
> true, or if one set of documentation is incorrect.

I'll await your feedback on this; but as the documentation available
to me would be
a rewrite of what you have I suspect we'll end up with your versions.
Just ping me
when you figure this one out and I'll respin.

Thanks for the review!

Regards,
Bjorn
