Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3LLUOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:14:41 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52175 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3LLUOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:14:38 -0500
Message-ID: <52AA192B.9090906@wwwdotorg.org>
Date: Thu, 12 Dec 2013 13:14:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: thierry.reding@gmail.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/4] ARM: tegra: convert dts files of all Tegra platforms
 to use pinctrl defines
References: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 03:44 AM, Laxman Dewangan wrote:
> This patch series convert dts files of all Tegra's platforms to use the pinctron
> dt-binding macro for better readability.

I've applied the series to Tegra's for-3.14/dt branch.
