Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3CTUuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:50:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44007 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3CTUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:50:24 -0400
Message-ID: <514A210D.4040507@wwwdotorg.org>
Date: Wed, 20 Mar 2013 14:50:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: tegra: enable Tegra114 based platform PMICs
References: <1363787070-14801-1-git-send-email-ldewangan@nvidia.com> <1363787070-14801-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363787070-14801-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 07:44 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 have two reference platform, Dalmore and Pluto.
> Dalmore uses the following PMICs:
> - TPS65913 as primary PMIC.
> - TPS65090 as secondary PMIC used for switch regulators and battery charging.
> - TPS51632 for cpu regulator.
> 
> Pluto uses the TPS65913 as the PMIC.
> 
> Enable config variable of these PMICs for Dalomore and Pluto.

Just FYI, I would apply the DT changes to Tegra's for-3.10/dt branch,
and the defconfig change to Tegra's for-3.10/defconfig branch. The /dt
branch will get merged first, and the /defconfig after it. Hence, you
would typically want to send patches in that order. It doesn't really
make any practical difference in this case though.
