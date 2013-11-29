Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3K2IKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:10:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51807 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab3K2IKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:10:46 -0500
Message-ID: <52984BAF.4060306@ti.com>
Date: Fri, 29 Nov 2013 13:39:19 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 4/6] gpio: davinci: add OF support
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>	<1385057731-4348-5-git-send-email-prabhakar.csengg@gmail.com>	<52932DB9.4090805@ti.com>	<5294950A.9070007@ti.com>	<5294D692.3080100@ti.com> <CACRpkdZtfsvgYNMUnuwiYL=0dVe6KDPV92Ri0TpTHL8gRJeqkQ@mail.gmail.com>
In-Reply-To: <CACRpkdZtfsvgYNMUnuwiYL=0dVe6KDPV92Ri0TpTHL8gRJeqkQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 November 2013 01:16 PM, Linus Walleij wrote:
> On Tue, Nov 26, 2013 at 6:12 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On Tuesday 26 November 2013 06:03 PM, Grygorii Strashko wrote:
> 
>>> Actually, the same was proposed by Linus, but we've tried avoid such huge rework -
>>> by switching to one irq_domain per all banks for example.
>>
>> I didn't really read that proposal from Linus so if two people
>> independently suggested the same thing, there must be something worth
>> considering there :)
> 
> From a GPIO POV it's not such a big deal really, this approach is fine
> and the important thing is that we progress toward a more standard
> driver... it's more a question for the DT people IMO. I really like the
> current patch set.

Rob has acked v5 of this patch. So no objection from DT people too. My
concern was a bit futuristic. Since everyone is happy I think we can go
with the current patch itself.

Thanks,
Sekhar
