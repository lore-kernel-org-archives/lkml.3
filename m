Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaHBHsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 03:48:19 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:55278 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaHBHsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 03:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140801182656.GJ30458@sirena.org.uk>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
	<20140801182656.GJ30458@sirena.org.uk>
Date: Sat, 2 Aug 2014 13:18:17 +0530
Message-ID: <CAJe_ZhcmEUDD3+xC2mBFnBm7uiMhibtHhBOMxVBhy700BTvYsA@mail.gmail.com>
Subject: Re: [PATCHv10 0/4] Common Mailbox Framework
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
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
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Kevin Hilman <khilman@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Andy Green <andy.green@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 August 2014 23:56, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Aug 01, 2014 at 05:59:54PM +0530, Jassi Brar wrote:
>> Hello,
>>  Here's v10. Not much different from v9. The code and the generic
>> bindings looked good enough to relevant gods, but the patchset still
>> needs some formal loving in the form of Acked-by's.
>>
>> Changes since v9:
>>  o Purely cosmetic changes - added headers and used BIT()
>
> Given that this code is now getting very stable can I suggest setting up
> a git tree and making sure it's included in -next?  Just send Stephen a
> mail with a pointer to the relevant tree and branch and ask him to add it.
>
> I'd say it's probably worth merging at this point though since it's not
> been in -next yet and the merge window is likely to open this weekend it
> might be a bit much to try to merge it this window.
>
Thanks, sounds good. Will do.

Regards,
Jassi
