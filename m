Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3CVJbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:31:22 -0400
Received: from sauhun.de ([89.238.76.85]:45083 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab3CVJbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:31:19 -0400
Date: Fri, 22 Mar 2013 10:31:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@wwwdotorg.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: check the clk_prepare_enable() return value
Message-ID: <20130322093114.GB8240@the-dreams.de>
References: <1363361648-10326-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363361648-10326-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 09:04:08PM +0530, Laxman Dewangan wrote:
> NVIDIA's Tegra SoC allows read/write of controller register only
> if controller clock is enabled. System hangs if read/write happens
> to registers without enabling clock.
> 
> clk_prepare_enable() can be fail due to unknown reason and hence
> adding check for return value of this function. If this function
> success then only access register otherwise return to caller with
> error.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied to for-current, thanks!
