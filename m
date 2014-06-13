Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaFMOLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:11:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:62402 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaFMOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:11:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marcel Ziswiler <marcel@ziswiler.com>
Subject: Re: [PATCH v2 1/3] arm: multi_v7: enable igb, stmpe, lm95245, pwm leds
Date: Fri, 13 Jun 2014 16:10:17 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, arm@kernel.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
References: <1741a33cd88cd5525f3c50c0e0cacc0853a3512a.1402350905.git.marcel@ziswiler.com>
In-Reply-To: <1741a33cd88cd5525f3c50c0e0cacc0853a3512a.1402350905.git.marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201406131610.18048.arnd@arndb.de>
X-Provags-ID: V02:K0:fVBo8vrdcujOURFpFhkI68OLbA+m/D2ET5lki3vCCIB
 ZxMuC04jVi4GwZxYkSg23uXJOMcF7m6gsozdqycTvfaiMeCs54
 817xIsDvRZ/FluJ1saJ1ECyueBtGbvjXW4zliAlvDQU12CcZht
 25q9ehplqYYOq9/KJM15W22F/D9wqAWl5eX3jij9sPuFsFVMYP
 3S/0pk7fMaLVvJn52TeJCooooXdo7i8MtnOAWpckY/EggC8Gra
 QJ9A/RoBDKJDwWmVI9lu56a0PKikrHQMyNRU60hvx+IVQPhMhA
 HX3rBwakQI07dzT0imFHqV/A5r2GbI3T3C4a5FN9ZJV7LWGv9m
 dYqp0zBnxZODJfp8ljec=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2014, Marcel Ziswiler wrote:
> The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
> i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller, PWM
> LEDs generically accessible from user space and an LM95245 temperature
> sensor chip. The later three can also be found on the Colibri T30
> module.
> 
> While at it move the NEON entry down to its proper place to have it all
> nicely ordered again.
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>

Stephen, Thierry,

do you want me to queue it up directly, or do you want to put it into
a tegra fixes branch?

	Arnd
