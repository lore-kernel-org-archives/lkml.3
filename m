Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3JULp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:45:57 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14651 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3JULpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:45:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Oct 2013 04:45:55 -0700
Message-ID: <52651A51.6030908@nvidia.com>
Date: Mon, 21 Oct 2013 17:43:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "mturquette@linaro.org" <mturquette@linaro.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nm@ti.com" <nm@ti.com>
Subject: Re: [PATCH V4] clk: palmas: add clock driver for palmas
References: <1381316687-1756-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1381316687-1756-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wednesday 09 October 2013 04:34 PM, Laxman Dewangan wrote:
> Palmas devices has two clock output CLK32K_KG and CLK32K_KG_AUDIO
> which can be enable/disable through software.
>
> Add clock driver support for the Palmas 32KHz clocks.


Can you please review this version? I have taken care of all earlier 
feedbacks.

Thanks,
Laxman
