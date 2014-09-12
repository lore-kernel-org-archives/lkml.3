Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaILEOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:14:15 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36846 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaILEOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:14:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140910101654.DA9BE897EF@gabe.freedesktop.org>
References: <20140910101654.DA9BE897EF@gabe.freedesktop.org>
Date: Fri, 12 Sep 2014 14:14:12 +1000
Message-ID: <CAPM=9tx-x1+qXOkqJi1OpvWinTHARWjMgHhgNZs91q2rMCETPw@mail.gmail.com>
Subject: Re: [PATCH v5] ASoC: tda998x: Add a codec to the HDMI transmitter
From: Dave Airlie <airlied@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mark Brown <broonie@kernel.org>,
        "Russell King - ARM Linux <linux@arm.linux.org.uk> Andrew Jackson" 
	<Andrew.Jackson@arm.com>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2014 19:29, Jean-Francois Moine <moinejf@free.fr> wrote:
> This patch adds a CODEC function to the NXP TDA998x HDMI transmitter.
>
> The CODEC handles both I2S and S/PDIF inputs.
> It maintains the audio format and rate constraints according
> to the HDMI device parameters (EDID) and does dynamic input
> switch in the TDA998x I2C driver on start/stop audio streaming.
>

You should indicate on subsystem spanning patches what tree you think
should merge it etc.

If other tda998x ppl are okay with it, you can have my ack for merging
via someone else.

Dave.
