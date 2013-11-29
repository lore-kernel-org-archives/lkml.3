Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3K2Iaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:30:52 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:37657 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3K2Iat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYvNwF+dxfiLCHpCL+Ze17PMAMkJo4s-4T4ku1KxDPXxw@mail.gmail.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com> <CACRpkdYvNwF+dxfiLCHpCL+Ze17PMAMkJo4s-4T4ku1KxDPXxw@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 29 Nov 2013 14:00:27 +0530
Message-ID: <CA+V-a8vZ22_OpfyEDcQoMWZJbUm3utBSJSrOZUw3ux2whZYXiQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] gpio: daVinci: cleanup and feature enhancement
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sekhar Nori <nsekhar@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Nov 29, 2013 at 1:17 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Nov 21, 2013 at 7:15 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch series does the following
>> 1> Ports the driver to use irqdomain.
>> 2> Adds dt binding support for gpio-davinci.
>> 3> Adds DA850 dt support goio.
>>
>> Changes for v6:
>> 1: GPIO driver now migrated to irq domain legacy.
>> 2: Fixed review comments pointed by Grygorii.
>> 3: Included Ack's.
>
> This series is looking nice, I assume that Sekhar will take this through
> the DaVinci tree once he's happy with it. I think I've ACKed all relevant
> patches, else tell me.
>
While you are at it, you missed to ACK v6 2/6 patch [1]

[1] https://lkml.org/lkml/2013/11/21/425

Regards,
--Prabhakar
