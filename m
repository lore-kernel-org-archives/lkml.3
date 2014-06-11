Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaFKNCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:02:07 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:47870 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaFKNCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqK0RqYuZ8YB1sBZK7hMXvp6oEPfAu11m95F61_kGV3Ptg@mail.gmail.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
	<bf4b6d7b061e66d3ca7f3dd44319b9e26ae7103f.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
	<CAMuHMdWirVk+jrz40yw4=zAOFH6VTX9CXcpO01e0rK8S8VGGHw@mail.gmail.com>
	<CAL_JsqK0RqYuZ8YB1sBZK7hMXvp6oEPfAu11m95F61_kGV3Ptg@mail.gmail.com>
Date: Wed, 11 Jun 2014 15:01:57 +0200
X-Google-Sender-Auth: V7lger-iGpnRHsTZpmaXPhRLTGQ
Message-ID: <CAMuHMdVD1Rui6NL6AS2iAaw+bmXbU6juA9ugO1rFSw_5W-49tA@mail.gmail.com>
Subject: Re: [PATCH 8/8] DT: Add vendor prefix for Dialog Semiconductor Ltd.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        support.opensource@diasemi.com,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Benoit Cousson <bcousson@baylibre.com>,
        Simon Horman <horms@verge.net.au>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 2:43 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Jun 11, 2014 at 7:09 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Wed, Jun 11, 2014 at 1:11 PM, Adam Thomson
>> <Adam.Thomson.Opensource@diasemi.com> wrote:
>>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>>> @@ -36,6 +36,7 @@ dallas        Maxim Integrated Products (formerly Dallas Semiconductor)
>>>  davicom        DAVICOM Semiconductor, Inc.
>>>  denx   Denx Software Engineering
>>>  digi   Digi International Inc.
>>> +dlg    Dialog Semiconductor Ltd.
>>
>> "diasemi" has been proposed before
>> https://groups.google.com/forum/#!msg/linux.kernel/htUxLpV_Ng0/ClJVAxgK4e4J
>>
>> "dialog", "diasemi", and "dlg" all seem to be already in use...
>
> dlg is the correct one and seems to be the most widely used, so we
> should go with that and mark the others deprecated.
>
> diasemi is documented for the da9210, but not used anywhere.

It users are queued in Simon's tree, for two Renesas boards.

> There appears to be 2 different da9053 bindings. I'd guess the dialog
> variant used on 2 i.MX boards is not used. Other i.MX boards use the
> dlg version. I'm not sure what is going on with da9055. Please sort
> these out.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
