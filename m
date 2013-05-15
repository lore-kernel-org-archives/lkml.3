Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab3EOB6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:58:33 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:60708 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab3EOB6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <1368544041.1350.111.camel@x61.thuisdomein>
References: <1368544041.1350.111.camel@x61.thuisdomein>
Date: Wed, 15 May 2013 09:58:30 +0800
Message-ID: <CAN1soZyUQRvDWcmefS3SnN=92rOp1LVknHFKzwqO6q88__ULMw@mail.gmail.com>
Subject: Re: [PATCH] ASoC: remove saarb and tavorevb3 machine drivers
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:07 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Support for PXA95x was removed in v3.8. This means that the Kconfig
> symbols MACH_SAARB and MACH_TAVOREVB3 are no longer available. This
> leaves the SoC Audio support for Marvell Saarb and Marvell Tavor EVB3
> unbuildable. Remove these drivers too.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
