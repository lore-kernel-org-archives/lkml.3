Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3LZWvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 17:51:06 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:43814 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3LZWvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 17:51:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alex Elder <alex.elder@linaro.org>, "Christian Daudt" <bcm@fixthebug.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Pawel Moll" <Pawel.Moll@arm.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Rob Landley" <rob@landley.net>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Stephen Warren" <swarren@wwwdotorg.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <52AF1BA5.6000902@linaro.org>
Cc: "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
References: <52AF1BA5.6000902@linaro.org>
Message-ID: <20131226225059.28468.61907@quantum>
User-Agent: alot/0.3.5
Subject: Re: [GIT PULL] clk: initial support  for Broadcom Kona clocks
Date: Thu, 26 Dec 2013 14:50:59 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alex Elder (2013-12-16 07:26:29)
> Mike, please pull the following for 3.14.  It adds clock support
> for Broadcom SoCs having "Kona" clock control units.  Thanks.

Pulled into clk-next.

Thanks!
Mike

> 
>                                         -Alex
> 
> The following changes since commit 1459c837036a44e2dcf14a9452ed330201fb23b5:
> 
>   clk: si570: Add a driver for SI570 oscillators (2013-12-14 21:01:35 -0800)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/landing-teams/working/broadcom/kernel.git
> pull/mturquette-kona-clocks
> 
> for you to fetch changes up to 143522e704d105bd2b3cbbca6e8fb2d217866ec0:
> 
>   clk: bcm281xx: add initial clock framework support (2013-12-16
> 07:34:52 -0600)
> 
> ----------------------------------------------------------------
> Alex Elder (2):
>       clk: bcm281xx: define kona clock binding
>       clk: bcm281xx: add initial clock framework support
> 
>  .../devicetree/bindings/clock/bcm-kona-clock.txt   |   93 ++
>  drivers/clk/Kconfig                                |    1 +
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/bcm/Kconfig                            |    8 +
>  drivers/clk/bcm/Makefile                           |    3 +
>  drivers/clk/bcm/clk-bcm281xx.c                     |  416 ++++++++
>  drivers/clk/bcm/clk-kona-setup.c                   |  769 +++++++++++++++
>  drivers/clk/bcm/clk-kona.c                         | 1033
> ++++++++++++++++++++
>  drivers/clk/bcm/clk-kona.h                         |  414 ++++++++
>  include/dt-bindings/clock/bcm281xx.h               |   65 ++
>  10 files changed, 2803 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
>  create mode 100644 drivers/clk/bcm/Kconfig
>  create mode 100644 drivers/clk/bcm/Makefile
>  create mode 100644 drivers/clk/bcm/clk-bcm281xx.c
>  create mode 100644 drivers/clk/bcm/clk-kona-setup.c
>  create mode 100644 drivers/clk/bcm/clk-kona.c
>  create mode 100644 drivers/clk/bcm/clk-kona.h
>  create mode 100644 include/dt-bindings/clock/bcm281xx.h
