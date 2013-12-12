Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3LLUQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:16:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55372 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3LLUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:16:18 -0500
Message-ID: <52AA198E.3050304@wwwdotorg.org>
Date: Thu, 12 Dec 2013 13:16:14 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org
CC: kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] ARM: tegra: correct Colibri T20 regulator settings
References: <cover.1386333697.git.stefan@agner.ch> <47b41f2de9c2651fbd2cded53c634a533d2740c1.1386333697.git.stefan@agner.ch>
In-Reply-To: <47b41f2de9c2651fbd2cded53c634a533d2740c1.1386333697.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 05:51 AM, Stefan Agner wrote:
> Set the parent of the regulators LDO2 to LDO9 according to the
> schematic. Set the base voltage to 3.3V, there is only 3.3V on the
> module itself.
> 
> Set the Core and CPU voltage to the specified voltages of 1.2V and
> 1.0V respectivly.
> 
> LDO6 should deliver 2.85V. The attached peripherals were not in
> use so far.

I've applied patch 3/3 only to Tegra's for-3.14/dt branch.
