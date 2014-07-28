Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaG1Iuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:50:50 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60473 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaG1Ius (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:50:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Benoit Masson <yahoo@perenite.com>, benoitm@perenite.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega ix4-300d NAS
Date: Mon, 28 Jul 2014 10:49:39 +0200
Message-ID: <5442226.1WCY4fjGCy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140727015244.GA31974@lunn.ch>
References: <1406418436-61452-1-git-send-email-yahoo@perenite.com> <20140727015244.GA31974@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ofT8sNz0TeeSah+Axjj847JS6/cHtf36EoiT/kfY+4t
 hkbNgw+z/tx8W1aYa9+G51vuScEoH5NOGwtUvdkrSNZXZ+PX/j
 ehHBDKTBxwfQNoWhuYvX4j2BBEHfvBlmQyoTBAdZPWEJ0KmBCc
 vClPNsOIr6oAXmG5O3PXab7R3XfvQVSedqXpUD2WDSTR9cuX0/
 +RhUmSCn6ua5upwjK22u2Ufb86xvpREx5xiJAjKEjBtOOMHjpD
 ou2jdqSuF5ZVatq8NDjetZxVGbr2JyPi/9N4x8URU0GiQx3mPn
 C1P0riRsucudRUFEGuUPW+ezfQLml6WvxnJHo2guXa7XP1oW06
 6xduFI4/e1s8NBIKcKW4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 July 2014 03:52:44 Andrew Lunn wrote:
> Hi Benoit
> 
> > +                     i2c@11000 {
> > +                             compatible = "marvell,mv78230-a0-i2c",
> > +                                     "marvell,mv64xxx-i2c";
> 
> The point of my patches is that you don't need the
> "marvell,mv78230-a0-i2c". It will work out at runtime if the SoC is A0
> stepping and automatically enable the workaround. Please test with
> only "marvell,mv64xxx-i2c";
> 

It should still list both "marvell,mv78230-i2c" and "marvell,mv64xxx-i2c",
as the generic name may not be enough to describe the register layout
correctly.

	Arnd
