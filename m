Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3LLVUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:20:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42358 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3LLVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:20:20 -0500
Message-ID: <52AA2891.2020502@wwwdotorg.org>
Date: Thu, 12 Dec 2013 14:20:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: thierry.reding@gmail.com, rob.herring@calxeda.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: enable ams AS3722 drivers
References: <1386855064-10993-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1386855064-10993-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 06:31 AM, Laxman Dewangan wrote:
> ams AS3722 is the system power manager module IC for the Tegra124 based
> Venice2 platform. Enable configs for gpio, pincontrol, rtc, regulator
> support from this device.

I've squashed patch 1/2 into Tegra's for-3.14/defconfig branch.

I've applied patch 2/2 to Tegra's for-3.14/dt branch.
