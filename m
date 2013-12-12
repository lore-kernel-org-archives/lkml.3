Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3LLUU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:20:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40318 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3LLUUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:20:54 -0500
Message-ID: <52AA1AA3.70303@wwwdotorg.org>
Date: Thu, 12 Dec 2013 13:20:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: thierry.reding@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: add default pinctrl nodes for Venice2
References: <1386585231-1183-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1386585231-1183-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 03:33 AM, Laxman Dewangan wrote:
> Add the default pinmux configuration for the Tegra124 based
> Venice2 platform.

Applied to Tegra's for-3.14/dt branch. I removed all the blank lines
between the nodes for consistency with the pinctrl state definitions in
other Tegra DT files.
