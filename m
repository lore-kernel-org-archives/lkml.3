Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaJKNwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 09:52:23 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:56490 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaJKNwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 09:52:20 -0400
MIME-Version: 1.0
In-Reply-To: <CABgxDoKo8RkM3etK7Yu+8vHQSWs-53wnZujF_QvXR0GJAwBfoA@mail.gmail.com>
References: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
 <CABgxDoL2cztT6Y0oodtk4Q4jaDc1Rtx_RokxC+f0XykSojrdyg@mail.gmail.com>
 <CACxGe6vmBSgGpJgJ51Ki5KbQO65GDw3kSGSxnswYMfE8OGj9gw@mail.gmail.com> <CABgxDoKo8RkM3etK7Yu+8vHQSWs-53wnZujF_QvXR0GJAwBfoA@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Sat, 11 Oct 2014 14:51:59 +0100
X-Google-Sender-Auth: UHWIqfn46X9f25TJECt3I30x3uA
Message-ID: <CACxGe6vsec80SDQFvZxStEcm8i6wTpa2ve7-r=n13-vZUjarcA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] regulator: Add helper function to get
 "poweroff-source" property
To: PERIER Romain <romain.perier@gmail.com>
Cc: devicetree <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, robh <robh@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 1:29 PM, PERIER Romain <romain.perier@gmail.com> wrote:
>>
>> What I'm more concerned about is the semantics of the property. What
>> do the generic code paths gain by standardizing this property? Is it
>> expected that
>
> We really need to come up with a standard property for this and document
> it rather than continuing to add individual device specific properties
> each time a driver adds poweroff capability,
> all doing the same thing (a lot of regulators driver, mfd drivers, soc
> specific drivers, power drivers already do that, that's very redudant)
> . This is a simple unification logic.

Yes, it's fine. I accidentally left that paragraph in when I sent my
reply. I started writing that concern, and then thought better of it.
The property is fine.

g.
