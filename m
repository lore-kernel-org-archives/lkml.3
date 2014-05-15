Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbaEOSiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:38:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60181 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbaEOSiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:38:09 -0400
Message-ID: <53750983.3080705@wwwdotorg.org>
Date: Thu, 15 May 2014 12:37:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: stefan@agner.ch
CC: thierry.reding@gmail.com, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        marcel@ziswiler.com
Subject: Re: [PATCH v2 3/3] ARM: tegra: initial add of Colibri T30
References: <cover.1400103181.git.stefan@agner.ch> <a8f01e573dcb7d563833ddcda30567e8ac7626ed.1400103181.git.stefan@agner.ch>
In-Reply-To: <a8f01e573dcb7d563833ddcda30567e8ac7626ed.1400103181.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 03:45 PM, stefan@agner.ch wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> This patch adds the device tree to support Toradex Colibri T30, a
> computer on module which can be used on different carrier boards.
> 
> The module consists of a Tegra 30 SoC, two PMIC, DDR3L RAM, eMMC,
> a LM95245 temperature sensor and an AX88772B USB Ethernet
> Controller. Furthermore, there is a STMPE811 and SGTL5000 audio
> codec which are not yet supported. Anything that is not self
> contained on the module is disabled by default.
> 
> The device tree for the Evaluation Board includes the modules
> device tree and enables the supported pheripherials of the carrier
> board (the Evaluation Board supports almost all of them).

I've applied this to Tegra's for-3.16/dt branch.

A changelog in each individual patch would be useful. Splitting out
patches for the DRM tree and the Tegra tree into different series would
be useful. In this case, they don't depend on each-other.
