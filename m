Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3FNTyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:54:36 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58761 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3FNTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:54:34 -0400
MIME-Version: 1.0
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EC213C8@DBDE01.ent.ti.com>
References: <1362629799-22485-1-git-send-email-mporter@ti.com>
	<1362629799-22485-3-git-send-email-mporter@ti.com>
	<41fde401c8e646689123d7c6d3a2dffc@DLEE71.ent.ti.com>
	<20130307141235.GQ6209@beef>
	<79CD15C6BA57404B839C016229A409A83EC20C57@DBDE01.ent.ti.com>
	<20130307144656.GR6209@beef>
	<79CD15C6BA57404B839C016229A409A83EC20CCA@DBDE01.ent.ti.com>
	<20130307150408.GU6209@beef>
	<79CD15C6BA57404B839C016229A409A83EC20D27@DBDE01.ent.ti.com>
	<20130307160236.GV6209@beef>
	<79CD15C6BA57404B839C016229A409A83EC213C8@DBDE01.ent.ti.com>
Date: Fri, 14 Jun 2013 14:54:33 -0500
Message-ID: <CAD=GYpb3+nvoz863+VKO7iJijRHnM5RzsVj-5VJfQ-OHoUy19Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
From: Joel A Fernandes <agnel.joel@gmail.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "Porter, Matt" <mporter@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, Vaibhav,

>> I just doublechecked MMC rootfs on bone and evmsk as it's the standard
>> smoke test. My EVM is intermittent now so trying to coax it to power up
>> to reverify.
>>
>
> Matt,
>
> Your branch is working for me, I tested it on EVM. Not sure what is wrong with manual rebasing
> I did yesterday. I will try to nail-down root-cause here.
>
> And you can submit the next version fixing the comments I have given.

The only comment I could find in the whole discussion was adding of
the interrupts property. I tested I don't have any problem booting
with Matt's patch, without having the interrupts property.

Can this patch be pulled in for 3.11?

Tested-by: Joel A Fernandes <joelagnel@ti.com>

Thanks,
Joel
