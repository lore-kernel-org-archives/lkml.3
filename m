Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3ISSZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:25:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60931 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3ISSZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:25:15 -0400
Message-ID: <523B4188.9020804@wwwdotorg.org>
Date: Thu, 19 Sep 2013 12:25:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: enable PALMAS_PINCTRL config
References: <1379509642-19227-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379509642-19227-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 07:07 AM, Laxman Dewangan wrote:
> PALMAS PMIC is used on Dalmore platform. Enable the pincontrol
> driver for Palmas to configure pins of Palmas on desired state.

I applied the series. Patch 1 (squash in)to Tegra's for-3.13/defconfig,
patch 2 to Tegra's for-3.13/dt branch.
