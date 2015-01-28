Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbbA2Bpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:45:44 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48802 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbbA2Bpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:45:42 -0500
Date: Wed, 28 Jan 2015 14:59:03 -0800
From: Olof Johansson <olof@lixom.net>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kukjin Kim <kgene@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: multi_v7_defconfig: Enable Exynos5420
 Multi-Cluster PM support
Message-ID: <20150128225903.GA3177@quad.lixom.net>
References: <1422456020-10975-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422456020-10975-1-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 03:40:20PM +0100, Javier Martinez Canillas wrote:
> The Exynos5420 cluster power management support allowing Exynos
> 5420/5422/5800 machines to power up and down the secondary CPUs.
> 
> Without this option enabled, the secondary CPUs are not brought
> up on boot and the following error is shown:
> 
> CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> Setting up static identity map for 0x40938e90 - 0x40938f28
> ARM CCI driver probed
> CPU1: failed to boot: -38
> CPU2: failed to boot: -38
> CPU3: failed to boot: -38
> CPU4: failed to boot: -38
> CPU5: failed to boot: -38
> CPU6: failed to boot: -38
> CPU7: failed to boot: -38
> Brought up 1 CPUs
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Applied, thanks.


-Olof
