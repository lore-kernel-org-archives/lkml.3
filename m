Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbbATKnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:43:00 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36322 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbbATKm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:42:58 -0500
Date: Tue, 20 Jan 2015 10:42:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        DT <devicetree@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Support Opensource <support.opensource@diasemi.com>
Subject: Re: [PATCH V2 2/2] devicetree: Add bindings for DA9063
Message-ID: <20150120104250.GR5767@x1>
References: <cover.1421684991.git.stwiss.opensource@diasemi.com>
 <7cd71ad47ba0cccd2d2da45fc3f1f82df0842a8c.1421684991.git.stwiss.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7cd71ad47ba0cccd2d2da45fc3f1f82df0842a8c.1421684991.git.stwiss.opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Steve Twiss wrote:

> From: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> Add device tree bindings for DA9063 regulators; Real-Time Clock
> and Watchdog.
> 
> This patch is dependent on PATCH V2 1/2 
> 
> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> ---
> This patch applies against linux-next and v3.19-rc4 
> 
>  Documentation/devicetree/bindings/mfd/da9063.txt | 94 ++++++++++++++++++++++++
>  1 file changed, 94 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/da9063.txt

Looks pretty standard.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
