Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871AbaKURir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:38:47 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:53768 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaKURip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:38:45 -0500
Date: Fri, 21 Nov 2014 17:38:44 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Vignesh R <vigneshr@ti.com>
cc: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] ARM: OMAP2+: hwmod: AM43x: add hwmod support for
 ADC on AM43xx
In-Reply-To: <1416564862-23056-2-git-send-email-vigneshr@ti.com>
Message-ID: <alpine.DEB.2.02.1411211737100.9204@utopia.booyaka.com>
References: <1416564862-23056-1-git-send-email-vigneshr@ti.com> <1416564862-23056-2-git-send-email-vigneshr@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Vignesh R wrote:

> This patch adds hwmod support for ADC on AM43xx. Since clockdomain
> and offsets of adc_tsc are different from AM33xx, ADC data has been
> directly added to AM43xx hwmod file.
> 
> Signed-off-by: Vignesh R <vigneshr@ti.com>

Thanks, will try to queue this for v3.19.  Will update my previous pull 
request.  Otherwise it's v3.20 material.

Note that I cannot test this patch locally due to the lack of an AM43xx 
board.


- Paul
