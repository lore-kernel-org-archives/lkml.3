Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaKKQvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:51:16 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:46776 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKKQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:51:14 -0500
MIME-Version: 1.0
In-Reply-To: <5461D2C1.6020505@redhat.com>
References: <cover.1415645258.git.rbyshko@gmail.com> <5461D2C1.6020505@redhat.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 12 Nov 2014 00:50:53 +0800
X-Google-Sender-Auth: XpZmVQvrKVi91PFgSU-22xOhMRA
Message-ID: <CAGb2v65=xbP+QMTBtVGRg6cEXHhsYda45yKHGrq9QfKcXozHiA@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v2 0/5] ARM: sunxi: Add support for USB OTG PHY
To: Hans De Goede <hdegoede@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Roman Byshko <rbyshko@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 5:11 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> On 11/10/2014 07:55 PM, Roman Byshko wrote:
>> Hi,
>>
>> There is already support for two USB phys, which are used for
>> USB host controllers on Allwinner SoC aka sunxi.
>>
>> This patch series add support for the USB OTG phy (aka phy0).
>>
>> The code has been tested on Allwinner A20 aka sun7i (Cubietruck).
>>
>> Best regards,
>> Roman Byshko
>
> First of all very cool that you're working on this, I somehow missed
> v1, but I'm very happy to see this.
>
> Second some questions, this series seems to only add support for
> initializing the phy, without adding the necessary magic for
> switching from app to host mode, and without actually hooking up musb,
> I assume you've a follow up series adding musb support, which actually
> uses the phy ?
>
> Also have you coordinated your work with ChenYu? ATM ChenYu is mostly
> working on other stuff, but AFAIk he has been working on musb support
> in the past.

I'm happy that someone has taken over. I was mostly just exploring what
OTG is, not much code actually made it into my working branch, which is
available on github.

ChenYu
