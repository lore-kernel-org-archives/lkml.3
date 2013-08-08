Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab3HHKKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:10:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193Ab3HHKKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:10:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH] Documentation: Add device tree binding file for MOXA ART SoCs interrupt controller
Date: Thu, 8 Aug 2013 12:09:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "arm@kernel.org" <arm@kernel.org>
References: <1374137426-6763-1-git-send-email-jonas.jensen@gmail.com> <20130802093559.GB2884@e106331-lin.cambridge.arm.com> <CACmBeS0wbCSU+3DJwtyN5CuX8GDCNWJxeiDq8YUrfTL8DwU_1w@mail.gmail.com>
In-Reply-To: <CACmBeS0wbCSU+3DJwtyN5CuX8GDCNWJxeiDq8YUrfTL8DwU_1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308081209.54412.arnd@arndb.de>
X-Provags-ID: V02:K0:2+EdH0PF2RKREJXGmAQyDG34mQbk99RVorYBlPGylHt
 xJaU9Uw8rGn+XIq6z5TEtW/3lD0PBtEwhhteUUL2y/hHruL/AQ
 fBuV+L888UtkVCqGTJQfoFZ3KhxYslytVrC3rT2O9athU6CU3b
 WpjMYOuqDmJItUy5LpwBOwKhG0vUV3Oil4udm2cLV4roNxDKnt
 Slrs27kU9PMVtkaVrpqPLEjf5ifwclIEqm8AaHoTybrFErlHh5
 MCgMx5/fo4tjJ5qfFleKMLCguzcJOVR8NXjCFjpRiNH/LUclO0
 1OvOlgvaMhv4V3S5YJl2eEC9NYgHXcLddzhMqTBfbHwW3rP3Fu
 0bO6yaGAvFWPE8fa63oc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 August 2013, Jonas Jensen wrote:
> It's true that "interrupt-mask" is redundant, DT "interrupts" hold the
> same information. I just never found nice way to collect it from DT.
> 
> See registers written on line 111:
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/irqchip/irq-moxart.c#n111
> 

Can't you just update the register whenever an interrupt gets mapped?

All unused interrupts can start out as edge triggered.

	Arnd
