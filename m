Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3AUJOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:14:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56996 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab3AUJOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:14:52 -0500
Message-ID: <50FD06FD.9080007@ti.com>
Date: Mon, 21 Jan 2013 10:14:37 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Jarkko Nikula <jarkko.nikula@bitmer.com>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Fix audio on Nokia RX-51
References: <1358651070-30029-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1358651070-30029-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/20/2013 04:04 AM, Pali Rohár wrote:
> This patch series updating rx51 sound driver, using snd_soc_register_card,
> adding module alias for autoloading kernel driver and registring sound
> driver in rx51 board code.
> 
> Pali Rohár (2):
>   ASoC: omap: rx51: Use snd_soc_register_card and add module alias for
>     autoloading driver
>   ARM: OMAP: rx51: Register audio device

Can you reverse the order of the patches so we will avoid to have non working
audio between the two patch?

> 
>  arch/arm/mach-omap2/board-rx51-peripherals.c |   11 ++++++
>  sound/soc/omap/rx51.c                        |   50 +++++++++++++++-----------
>  2 files changed, 41 insertions(+), 20 deletions(-)
> 


-- 
Péter
