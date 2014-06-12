Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaFLTzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:55:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35575 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaFLTzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:55:17 -0400
Message-ID: <539A0357.6070403@wwwdotorg.org>
Date: Thu, 12 Jun 2014 13:45:27 -0600
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

This looks OK; I'll apply once the merge window is done.

> diff --git a/arch/arm/boot/dts/tegra30-apalis-eval.dts b/arch/arm/boot/dts/tegra30-apalis-eval.dts

> +	pwmleds {
...
> +		pwm3 {
> +		pwm2 {
> +		pwm1 {

Those still aren't sorted. I'll try and remember to fix that when I
apply it.
