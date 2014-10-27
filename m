Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaJ0LmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:42:06 -0400
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:55659 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751149AbaJ0LmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:42:05 -0400
X-Greylist: delayed 13122 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 07:42:04 EDT
Message-ID: <544DFC31.4090307@neo-technologies.fr>
Date: Mon, 27 Oct 2014 09:02:57 +0100
From: NEO-Technologies / Julien CHAUVEAU 
	<julien.chauveau@neo-technologies.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: rockchip: use internal pull-up resistors on
 I2C busses
References: <1413556830-27854-1-git-send-email-julien.chauveau@neo-technologies.fr> <8843018.dv9ckEkBvo@diego>
In-Reply-To: <8843018.dv9ckEkBvo@diego>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 18172868921916784865
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-01-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

Le 27/10/2014 01:27, Heiko Stübner a écrit :
> The rk3066a does not support distinguishing between up and down pulls. On it
> only &pcfg_pull_default is possible that configures the pull to a pin-specific
> pull direction. For the i2c pins the direction is (of course) "up".

Thank you for the information. I will send a new patch to fix the pull 
configuration for the rk3066a.

Julien
