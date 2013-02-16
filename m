Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3BPF5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:57:32 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:43047 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3BPF5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:57:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAFRkauBxV6sqN7w-YSE_tMZAJAOF2YANGzrU51btRT2Mz+fsNQ@mail.gmail.com>
References: <1360919961.23894.2.camel@phoenix>
	<CAN1soZw5k7DBrPOi4iMhsoiGJ_Z5EsYQuFLAjhUiCYsuGxa6ig@mail.gmail.com>
	<CAFRkauBxV6sqN7w-YSE_tMZAJAOF2YANGzrU51btRT2Mz+fsNQ@mail.gmail.com>
Date: Sat, 16 Feb 2013 13:57:29 +0800
Message-ID: <CAN1soZx+RYcQxj=RAHEehxPOP+ua0_chJYeieKLPD9rEfXpM-A@mail.gmail.com>
Subject: Re: [RFC/RFT][PATCH 1/3] regulator: core: Add enable_pulldown flag to
 indicate pulldown on EN input
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 1:35 PM, Axel Lin <axel.lin@ingics.com> wrote:
>
>> I think that enable_pulldown is a little hard to understand. How about
>> change
>> the name, like set_to_disable or something else?
>
>
> How about "enable_invert"?
> ( We have ena_gpio_invert setting for GPIO controlled enable lines )
>
> Then I'll update the comments to:
> @enable_invert: A flag to indicate set enable_mask bits to disable when
> using
>                 regulator_enable_regmap and friends APIs.
>
> Axel

enable_is_inverted is better.
