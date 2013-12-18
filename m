Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3LRU4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:56:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37129 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3LRU4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:56:48 -0500
Message-ID: <52B20C0D.9030200@wwwdotorg.org>
Date: Wed, 18 Dec 2013 13:56:45 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, thierry.reding@gmail.com
CC: mark.rutland@arm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: fix missing pincontrol configuration
 for Venice2
References: <1387371179-16725-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1387371179-16725-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 05:52 AM, Laxman Dewangan wrote:
> Compare the initial population of default pinmux configuration of Venice2
> with the chrome branch and add/fix the missing configurations.

Wow, that's a big chunk of changes. Are you sure this is correct? Why
was the original patch (which added the pinctrl nodes) so incorrect?

Thierry, I thought you had mentioned comparing the pinctrl setup in
linux-next with the downstream kernel for Venice2 and only found a
difference in the PWM settings, which you sent a patch for. However,
this patch is much larger than that. Where's the disconnect?
