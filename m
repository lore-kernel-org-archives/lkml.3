Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab3FRVTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:19:55 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:58381 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3FRVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:19:54 -0400
Message-ID: <51C0CEEE.5020208@elopez.com.ar>
Date: Tue, 18 Jun 2013 18:19:42 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [PATCHv2] ARM: sunxi: Add Olimex A10s-Olinuxino-micro device
 tree
References: <1371458757-6343-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1371458757-6343-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 17/06/13 05:45, Maxime Ripard escribió:
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Tested-by: Emilio López <emilio@elopez.com.ar>

Looks good now,

Acked-by: Emilio López <emilio@elopez.com.ar>

Thanks!

Emilio

> ---
>  arch/arm/boot/dts/Makefile                       |  1 +
>  arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts | 76 ++++++++++++++++++++++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts
