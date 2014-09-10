Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaIJC35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:29:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13278 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaIJC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:29:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18at+NrJ3fKYFWoL041R3sd
Date: Wed, 10 Sep 2014 02:29:49 +0000
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Beno??t Cousson <bcousson@baylibre.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] ARM: dts: OMAP5 / DRA7: pinctrl updates
Message-ID: <20140910022949.GB1058@atomide.com>
References: <1410271178-28336-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410271178-28336-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140909 14:00]:
> 
> Hi Tony,
> 
> Please pull this series was posted[1] and based on the previous pulls
> [2] [3], updating the dts to enable the relevant feature.
> 
> NOTE: I have dropped patch #1 of the series based on [4].
> 
> These could go to your branch omap-for-v3.18/dt
> 
> The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
> 
>   Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
> 
> are available in the git repository at:
> 
>   https://github.com/nmenon/linux-2.6-playground.git pull/v3.18/for-dt-pinctrl-updates
> 
> for you to fetch changes up to 66b0436977e2c62388d48836ff784f1fedb49c4f:
> 
>   ARM: dts: dra7-evm: Mark uart1 rxd as wakeup capable (2014-09-09 08:33:29 -0500)

Thanks pulling into omap-for-v3.18/dt.

Tony
 
> ----------------------------------------------------------------
> Nishanth Menon (5):
>       ARM: dts: OMAP5: switch to compatible pinctrl
>       ARM: dts: DRA7: switch to compatible pinctrl
>       ARM: dts: AM437x: switch to compatible pinctrl
>       ARM: dts: OMAP5 / DRA7: switch over to interrupts-extended property for UART
>       ARM: dts: dra7-evm: Mark uart1 rxd as wakeup capable
> 
>  arch/arm/boot/dts/am4372.dtsi  |    4 +++-
>  arch/arm/boot/dts/dra7-evm.dts |    2 ++
>  arch/arm/boot/dts/dra7.dtsi    |   24 +++++++++++++-----------
>  arch/arm/boot/dts/omap5.dtsi   |   20 ++++++++++++--------
>  4 files changed, 30 insertions(+), 20 deletions(-)
> 
> [1] http://marc.info/?l=linux-kernel&m=140871681606779&w=2
> [2] http://marc.info/?l=linux-kernel&m=141019565513129&w=2
> [3] http://marc.info/?l=linux-kernel&m=141019566913133&w=2
> [4] http://marc.info/?l=linux-omap&m=141022429924564&w=2
> 
> Regards,
> Nishanth Menon
> 
