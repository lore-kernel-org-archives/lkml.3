Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3J2Mmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:42:45 -0400
Received: from muin.pair.com ([209.68.1.55]:62746 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3J2Mmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:42:44 -0400
Message-ID: <526FAD41.2000805@tabi.org>
Date: Tue, 29 Oct 2013 07:42:41 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Firefox/24.0 SeaMonkey/2.21
MIME-Version: 1.0
To: Nicolin Chen <b42378@freescale.com>, shawn.guo@linaro.org,
        broonie@kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, rob.herring@calxeda.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, s.hauer@pengutronix.de,
        b32955@freescale.com
Subject: Re: [PATCH 2/3] ASoC: fsl_ssi: Add dual fifo mode support
References: <cover.1383047327.git.b42378@freescale.com> <02f8867363ed3038a0a70703856e4b642fef4339.1383047327.git.b42378@freescale.com>
In-Reply-To: <02f8867363ed3038a0a70703856e4b642fef4339.1383047327.git.b42378@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolin Chen wrote:
> By enabling dual fifo mode, it would allow SSI enter a better performance
> to transimit/receive data without occasional hardware underrun/overrun.

Have you measured any real performance gain with this patch?  I 
considered adding dual-FIFO support when I originally wrote this driver, 
but it didn't appear to have any real benefit, but it used twice as many 
DMA channels.

I'm concerned that this is another patch that just enables a useless 
feature.
