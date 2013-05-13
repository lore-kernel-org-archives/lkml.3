Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3EMT3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:29:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3EMT3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:29:05 -0400
Message-ID: <51913EFE.6030103@wwwdotorg.org>
Date: Mon, 13 May 2013 13:29:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: dalmore: populate key mapping
References: <1365594454-20614-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1365594454-20614-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 05:47 AM, Laxman Dewangan wrote:
> Keys on Dalmore interfaced through Tegra KBC controller
> in key matrix topology.
> 
> Add the key mapping for the keys.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> The system is booted on Dalmore SKU1000 with the fastboot.

I don't intend applying these two patches.

For Dalmore, there are two SKUs, one using KBC and one using GPIOs for
the buttons/keys. The SKU that uses GPIOs is far more common, so we've
decided to support that one upstream.

We aren't actively pursuing Pluto support upstream; it's likely that
I'll send a patch to remove tegra114-pluto.dts in the near future.
