Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBGRTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:19:54 -0500
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:56276 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbaBGRTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:19:53 -0500
X-Greylist: delayed 30961 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Feb 2014 12:19:53 EST
Date: Fri, 7 Feb 2014 18:20:55 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        arm@kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>,
        jjhiblot@traphandler.com, Bo Shen <voice.shen@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.14 #1
Message-ID: <20140207172055.GC9558@ns203013.ovh.net>
References: <1391790986-31936-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391790986-31936-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 1598496392815487852
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:36 Fri 07 Feb     , Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is a first "fixes" series for AT91 on 3.14.
> The content is only DT-related and quite boring.
> I took the opportunity of this early "fixes" pull-request to collect
> some Documentation patches that were lying around and I guess that
> they can be merged by arm-soc nicely (addition of CCF to 2 drivers).
> A new board is added to the lot because it is dead simple and integrates
> well with the new sama5d36 SoC that we added earlier in this development cycle.
> 
> Thanks, best regards,
> 
> The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:
> 
>   Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
> 
> for you to fetch changes up to b7c2b6157079811586180d13c44a1095b57c2d47:
> 
>   ARM: at91: add Atmel's SAMA5D3 Xplained board (2014-02-07 17:20:39 +0100)
> 
> ----------------------------------------------------------------
> First series of AT91 fixes for 3.14.
> All of them are DT-related.
> - fixes for typos in i2c and ohci clocks
> - addition of a USB host node for at91sam9n12ek
> - 2 DT documentation updates that have been sent a long time ago
> - a new board based on the sama5d36 SoC
> 
> ----------------------------------------------------------------
> Bo Shen (1):
>       ARM: at91: enable USB host on at91sam9n12ek board
> 
> Boris BREZILLON (3):
>       ARM: at91/dt: fix sama5d3 ohci hclk clock reference
>       mmc: atmel-mci: document clock properties
>       spi/atmel: document clock properties
> 
> Jean-Jacques Hiblot (1):
>       ARM: at91/dt: sam9263: fix compatibility string for the I2C
> 
> Nicolas Ferre (1):
>       ARM: at91: add Atmel's SAMA5D3 Xplained board

still comment on it please drop it on the PULL

Best Regards,
J.
> 
>  .../devicetree/bindings/mmc/atmel-hsmci.txt        |   5 +
>  .../devicetree/bindings/spi/spi_atmel.txt          |   5 +
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/at91-sama5d3_xplained.dts        | 229 +++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9263.dtsi                 |   2 +-
>  arch/arm/boot/dts/at91sam9n12ek.dts                |   4 +
>  arch/arm/boot/dts/sama5d3.dtsi                     |   2 +-
>  7 files changed, 246 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91-sama5d3_xplained.dts
> 
> -- 
> Nicolas Ferre
