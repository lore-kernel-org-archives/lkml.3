Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaFEPwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:52:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32817 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaFEPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:51:57 -0400
Message-ID: <53909219.6090200@wwwdotorg.org>
Date: Thu, 05 Jun 2014 09:51:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, olof@lixom.net,
        "arm@kernel.org" <arm@kernel.org>
CC: Stephen Warren <swarren@nvidia.com>, Thierry Reding <treding@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, galak@codeaurora.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: dts: Create a cros-ec-keyboard fragment
References: <1401920421-25729-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1401920421-25729-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 04:20 PM, Doug Anderson wrote:
> All ChromeOS ARM devices that have the standard "CrOS EC" have the
> same keyboard mapping.  It's silly to include this same definition
> everywhere.  Let's create a "dtsi" fragment that we can include from
> many different boards.
> 
> This fragment is based on what's currently in tegra124-venice2.dts

This series looks fine to me. Given it touches both Tegra and Exynos,
should it be merged into a topic branch in arm-soc, so that it can be
pulled into both Tegra/Exynos trees to resolve any conflicts. So,

Acked-by: Stephen Warren <swarren@nvidia.com>

If you want, I'm happy to apply this to a topic branch and send a pull
request to arm-soc.
