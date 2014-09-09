Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbaIIQYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:24:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38069 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbaIIQYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:24:34 -0400
Message-ID: <540F299A.6030906@ti.com>
Date: Tue, 9 Sep 2014 11:23:54 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>, Mark Brown <broonie@kernel.org>
CC: Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Kevin Hilman <khilman@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Andy Green <andy.green@linaro.org>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCHv10 0/4] Common Mailbox Framework
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>	<20140801182656.GJ30458@sirena.org.uk> <CAJe_ZhcmEUDD3+xC2mBFnBm7uiMhibtHhBOMxVBhy700BTvYsA@mail.gmail.com>
In-Reply-To: <CAJe_ZhcmEUDD3+xC2mBFnBm7uiMhibtHhBOMxVBhy700BTvYsA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jassi,

On 08/02/2014 02:48 AM, Jassi Brar wrote:
> On 1 August 2014 23:56, Mark Brown <broonie@kernel.org> wrote:
>> On Fri, Aug 01, 2014 at 05:59:54PM +0530, Jassi Brar wrote:
>>> Hello,
>>>  Here's v10. Not much different from v9. The code and the generic
>>> bindings looked good enough to relevant gods, but the patchset still
>>> needs some formal loving in the form of Acked-by's.
>>>
>>> Changes since v9:
>>>  o Purely cosmetic changes - added headers and used BIT()
>>
>> Given that this code is now getting very stable can I suggest setting up
>> a git tree and making sure it's included in -next?  Just send Stephen a
>> mail with a pointer to the relevant tree and branch and ask him to add it.
>>
>> I'd say it's probably worth merging at this point though since it's not
>> been in -next yet and the merge window is likely to open this weekend it
>> might be a bit much to try to merge it this window.
>>
> Thanks, sounds good. Will do.

Is there anything pending on this series to make it into 3.18?

This is one of the dependencies for our AM335/AM437 PM suspend support,
so it would be great to see this in 3.18, so that we can target 3.19 for
the PM series.

regards
Suman


