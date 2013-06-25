Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3FYPxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:53:48 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38010 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3FYPxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:46 -0400
MIME-Version: 1.0
In-Reply-To: <51C9B9AB.2010403@wwwdotorg.org>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
	<1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
	<51BA3BC1.3090109@wwwdotorg.org>
	<20130614091241.GA23745@ab42.lan>
	<51C1F42E.5090107@wwwdotorg.org>
	<51C1F82C.4020502@wwwdotorg.org>
	<20130620115710.GB942@ab42.lan>
	<51C4C2ED.5090505@wwwdotorg.org>
	<CACRpkdZQ=G=K6g25gwGKfS1dCrDS35XepaOs38N-ymEuR0+x=g@mail.gmail.com>
	<51C9B9AB.2010403@wwwdotorg.org>
Date: Tue, 25 Jun 2013 17:53:45 +0200
Message-ID: <CACRpkdYoK7x0RJH3eR-gCTT6cfCD2sas3E_O_j4ALS6gHoxw+A@mail.gmail.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 5:39 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/25/2013 09:28 AM, Linus Walleij wrote:

>> But I do seem to recall some endless discussions about this,
>> I think we need to agree to disagree.
>
> But the whole point of a subsystem is to provide clear common semantics
> across all the different drivers that comprise it.

I guess we simply disagree on how deeply these semantics
should go.

> IMHO, it's a great
> failing of pinctrl that it doesn't clearly define its data model at all,
> and just leaves individual driver authors to use groups in whatever
> random fashion they want.

I do not think any driver is using it in a "random" fashion.
I would agree if the authors just stuck any pins into some
random groups named after colors or rock bands.

Obviously there is a mental model of the uses somewhere
behind the code.

> We really should have different entries in the
> pinctrl data model for these different concepts (real HW groups, and
> logical/virtual/SW groups) since they're entirely different things with
> different semantics.

That's what the tongue-in-cheek patch tried to convey, in some
kind of humorous manner. I was just trying to lighten up the
discussion a bit.

> Perhaps it's simplest if I just step out of pinctrl and let it exist as
> it is.

No not at all. Your work on defining and reviewing the pinctrl
drivers and DT bindings is much appreciated. However all
comittee work tend to lead to a few compromises. I don't
think this one compromise is especially hard to live with.

Yours,
Linus Walleij
