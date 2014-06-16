Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaFPTOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:14:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41046 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbaFPTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:14:34 -0400
Message-ID: <539F4216.70102@wwwdotorg.org>
Date: Mon, 16 Jun 2014 13:14:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH v2 3/3] arm: tegra: initial support for apalis t30
References: <dadd07f9ed693d6bcf541764b62a2caf4cc38630.1402353627.git.marcel@ziswiler.com> <95c131deb3e410e8defc9fe125dc662bdb276310.1402353627.git.marcel@ziswiler.com>
In-Reply-To: <95c131deb3e410e8defc9fe125dc662bdb276310.1402353627.git.marcel@ziswiler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 04:52 PM, Marcel Ziswiler wrote:
> This patch adds the device tree to support Toradex Apalis T30, a
> computer on module which can be used on different carrier boards.
> 
> The module consists of a Tegra 3 SoC, two PMICs, 1 or 2 GB of DDR3L
> RAM, eMMC, an LM95245 temperature sensor chip, an i210 resp. i211
> gigabit Ethernet controller, an STMPE811 ADC/touch controller as well
> as two MCP2515 CAN controllers. Furthermore, there is an SGTL5000 audio
> codec which is not yet supported. Anything that is not self contained
> on the module is disabled by default.
> 
> The device tree for the Evaluation Board includes the modules device
> tree and enables the supported peripherals of the carrier board (the
> Evaluation Board supports almost all of them).
> 
> While at it also add the device tree binding documentation for Apalis
> T30.

Applied to Tegra's for-3.17/dt branch.
