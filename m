Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaG3Rh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:37:26 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57858 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaG3RhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:37:23 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:2811:8aec:a585:9833]
In-Reply-To: <20140730133309.GF9809@8bytes.org>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
	<20140730110425.GI12239@arm.com>
	<20140730132348.GM29590@ulmo>
	<20140730133309.GF9809@8bytes.org>
Date: Wed, 30 Jul 2014 10:37:22 -0700
Message-ID: <CAOesGMgKzbGe0uZEH84i=uYttcweUaZfEeRgCU9dUd43T+pP2g@mail.gmail.com>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
From: Olof Johansson <olof@lixom.net>
To: Joerg Roedel <joro@8bytes.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 6:33 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Wed, Jul 30, 2014 at 03:23:50PM +0200, Thierry Reding wrote:
>> I think there weren't any comments left for me to address and I've
>> mostly been waiting for Joerg to pick it up.
>>
>> Joerg, can you take this through the iommu tree for 3.17? Will acked
>> this, but perhaps you were waiting for an ACK from the device tree
>> bindings maintainers?
>>
>> Will, perhaps you can get Pawel or Mark to look at this?
>>
>> Arnd, I'm sure if we had your Acked-by that would go a long way too.
>
> Yes, as Arnd requested this generic binding it would be good to have his
> Acked-by before proceeding. Arnd?

Arnd is on vacation now, unfortunately. I've read up on the history
and the current proposal from Thierry looks sane to me. As discussed,
there might be a need for some common helpers to walk the tree and
figure out things.

There's also the possibility that the IOMMU at init time actually
modifies and configures the stream IDs for the clients, but that again
is an implementation detail and not something that affects the binding
per se.

I'm not giving my Ack now since I want to make sure there are no
disagreements on my separate reply from a minute ago, but I expect
you'll have it once we've had that round trip of comments. :)


-Olof
