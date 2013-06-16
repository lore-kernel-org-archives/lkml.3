Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3FPLLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:11:25 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:63266 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3FPLLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130611072743.GA14802@ab42.lan>
References: <20130522142824.GC4789@ab42.lan>
	<CAD6h2NT4FqmEsLvtTDwwDL2YVzXYNpw72hTOcSxSMvHLhWvFPQ@mail.gmail.com>
	<20130524115053.GB5203@ab42.lan>
	<CAD6h2NSh_4TNAGeFhg+va5QX2hGia+gkw-mPaeMezghsa=Zc6Q@mail.gmail.com>
	<20130603123001.GD31808@ab42.lan>
	<CAD6h2NQVKKvcoPdD4sm5rUM5G-FpF3abL=k+WfQsnKnm7qhREA@mail.gmail.com>
	<20130606141115.GA10345@ab42.lan>
	<CAD6h2NRNMQP-ZQ0Cc613tGThVEo7AzRExBmWsbtr1DXgiPwz7w@mail.gmail.com>
	<20130606153030.GA19876@ab42.lan>
	<51B2320B.6060101@wwwdotorg.org>
	<20130611072743.GA14802@ab42.lan>
Date: Sun, 16 Jun 2013 13:11:23 +0200
Message-ID: <CACRpkdZ=WarECW3xhMv2woWJW7JxgoMH73Yufep6VyLkzBGiXQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 9:27 AM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:
> On Fri, Jun 07, 2013 at 01:18:35PM -0600, Stephen Warren wrote:

>> However, then the correlation between these pretend pins (i.e. really
>> the groups) and GPIOs won't work, because each "pin" is really 4 pins,
>> and hence 4 GPIOs, and hence you won't be able to gpio_get() more than 1
>> GPIO per pin group, I think.
>
> I agree: Unluckily, pinctrl-single doesn't seem to be what we are looking
> for.

I agree on this conclusion.

> We already have a draft for a native pinctrl driver (see original post)
> but there was some disagreement about exposing kernel internal pin
> numbering to device tree users.

But that is an orthogonal issue I believe.

Yours,
Linus Walleij
