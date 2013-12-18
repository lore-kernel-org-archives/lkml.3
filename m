Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3LRUzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:55:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56436 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3LRUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:55:20 -0500
Message-ID: <52B20BB4.50506@wwwdotorg.org>
Date: Wed, 18 Dec 2013 13:55:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: thierry.reding@gmail.com, mark.rutland@arm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] ARM: tegra: add ams AS3722 device to Venice2 DT
References: <1387371179-16725-1-git-send-email-ldewangan@nvidia.com> <1387371179-16725-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1387371179-16725-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 05:52 AM, Laxman Dewangan wrote:
> Add ams AS3722 entry for gpio/pincontrol and regulators
> to venice2 DT.

This patch still causes:

> [    0.726545] as3722-pinctrl as3722-pinctrl: pin gpio0 already requested by as3722-pinctrl; cannot claim for as3722-regulator
> [    0.737681] as3722-pinctrl as3722-pinctrl: pin-0 (as3722-regulator) status -22
> [    0.744895] as3722-pinctrl as3722-pinctrl: could not request pin 0 (gpio0) from group gpio0  on device as3722-pinctrl
> [    0.755500] as3722-regulator as3722-regulator: Error applying setting, reverse things back

