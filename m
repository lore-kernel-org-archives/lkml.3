Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3CaHqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 03:46:14 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39476 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3CaHqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 03:46:13 -0400
Date: Sun, 31 Mar 2013 00:46:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] input: keyboard: tegra: support for defining
 row/columns based on SoC
Message-ID: <20130331074609.GG7919@core.coreip.homeip.net>
References: <1363194873-13723-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363194873-13723-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 10:44:33PM +0530, Laxman Dewangan wrote:
> NVIDIA's Tegra20 and Tegra30 supports the 16x8 keyboard matrix and T114
> support the 11x8 Key matrix.
> 
> Add support for defining the maximum row/columns based on SoC through
> proper compatibity.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Applied, thank you Laxman.

-- 
Dmitry
