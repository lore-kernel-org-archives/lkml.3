Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3A1W7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:59:21 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:41732 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3A1W7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:59:20 -0500
Date: Mon, 28 Jan 2013 14:59:17 -0800
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>, arm@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/5] pinctrl/abx500: add AB8500 sub-driver
Message-ID: <20130128225917.GD7789@quad.lixom.net>
References: <1359380995-27950-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359380995-27950-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 02:49:55PM +0100, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@st.com>
> 
> This adds a subdriver for the AB8500 pinctrl portions.
> As the pin controller (also the ABx500 controllers) is an
> inherent part of the SoC and will prevent boot if not
> available, select this from the Ux500 SoC Kconfig.
> 
> Cc: arm@kernel.org
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Requesting an ACK from the ARM SoC maintainers for this patch.

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
