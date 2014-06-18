Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaFRPxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:53:45 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62954 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaFRPxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:53:42 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
	<7hvbrzbh1u.fsf@paris.lan>
	<CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com>
Date: Wed, 18 Jun 2014 08:53:40 -0700
In-Reply-To: <CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com>
	(Bjorn Andersson's message of "Tue, 17 Jun 2014 10:15:10 -0700")
Message-ID: <7hzjha8b97.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Andersson <bjorn@kryo.se> writes:

> On Tue, Jun 17, 2014 at 10:07 AM, Kevin Hilman <khilman@linaro.org> wrote:
>> +Paul Walmsley
>>
>> Bjorn Andersson <bjorn.andersson@sonymobile.com> writes:
>>
>>> This series adds a regulator driver for the Resource Power Manager found in
>>> Qualcomm 8660, 8960 and 8064 based devices.
>>>
>>> The RPM driver exposes resources to its child devices, that can be accessed to
>>> implement drivers for the regulators, clocks and bus frequency control that's
>>> owned by the RPM in these devices.
>>>
>>> Changes since v2:
>>>   - Fix copy-paste error in dt binding
>>>   - Correct incomplete move from mfd to soc
>>>   - Correct const mistake in regulator driver
>>>
>>> Changes since v1:
>>>   - Moved rpm driver to drivers/soc
>>
>> I'm not sure I follow the motivation for having this under drivers/soc?
>>
> Hi Kevin,
>
> I've made the argument that to me this is conceptually a black box
> handling regulators, clocks and other stuff; hence similar to a PMIC,
> which would fit nicely into drivers/mfd.
>
> I still think this is the case and now that I look back I didn't get
> any pushback from Lee Jones so maybe the move was premature?

Yes, IMO, the move was premature, but hopefully the drivers/soc folks
can chime in an clarify the criteria for inclusion there.

Kevin

