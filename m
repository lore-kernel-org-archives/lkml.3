Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbbAIKWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:22:16 -0500
Received: from smtp-3.sys.kth.se ([130.237.48.192]:37039 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbbAIKWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:22:14 -0500
X-KTH-Auth: niso [89.233.231.155]
X-KTH-mail-from: niso@kth.se
Date: Fri, 9 Jan 2015 11:22:06 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niso@kth.se>
To: linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        linus.walleij@linaro.org
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH 0/4] sh-pfc: Add emev2 pinmux support
Message-ID: <20150109102206.GB30143@bigcity.berto.se>
References: <1418414497-23741-1-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418414497-23741-1-git-send-email-niso@kth.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus and Laurent,

I know we are coming out of the holiday season so here is a humble ping
on this patchset.

* Niklas Söderlund <niso@kth.se> [2014-12-12 21:01:33 +0100]:

> Greetings,
>
> This patchset introduces pinmux support for the EMMA Mobile EV2 board to
> the sh-pfc pin-controller driver. Devicetree bindings for gpio and the
> populated serial connector are also defined in 3/4 and 4/4.
>
> Comments are welcome!
>
> Regards
> // Niklas
>
> Niklas Söderlund (4):
>   sh-pfc: add macro to define pinmux without function
>   sh-pfc: Add emev2 pinmux support
>   ARM: shmobile: emev2: Add PFC information to emev2.dtsi
>   ARM: shmobile: emev2-kzm9d: Add PFC information for uart1
>
>  .../bindings/pinctrl/renesas,pfc-pinctrl.txt       |    1 +
>  arch/arm/boot/dts/emev2-kzm9d.dts                  |   13 +
>  arch/arm/boot/dts/emev2.dtsi                       |   11 +
>  drivers/pinctrl/sh-pfc/Kconfig                     |    5 +
>  drivers/pinctrl/sh-pfc/Makefile                    |    1 +
>  drivers/pinctrl/sh-pfc/core.c                      |    9 +
>  drivers/pinctrl/sh-pfc/core.h                      |    1 +
>  drivers/pinctrl/sh-pfc/pfc-emev2.c                 | 1915 ++++++++++++++++++++
>  drivers/pinctrl/sh-pfc/sh_pfc.h                    |    2 +
>  9 files changed, 1958 insertions(+)
>  create mode 100644 drivers/pinctrl/sh-pfc/pfc-emev2.c
>
> --
> 2.1.3
>
