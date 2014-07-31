Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaGaNKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:10:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52554 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaGaNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:10:01 -0400
Message-ID: <53DA4022.3040906@gmail.com>
Date: Thu, 31 Jul 2014 15:09:54 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Silva Naves <hsnaves@gmail.com>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv2 3/5] clk: samsung: exynos5410: Add suspend/resume handling
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com> <1406805732-17372-4-git-send-email-hsnaves@gmail.com>
In-Reply-To: <1406805732-17372-4-git-send-email-hsnaves@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Humberto,

On 31.07.2014 13:22, Humberto Silva Naves wrote:
> This patch implements all the necessary code that handles register
> saving and restoring during a suspend/resume cycle. To make this
> possible, the local variable reg_base from the function
> exynos5410_clk_init was changed to global. In addition, new
> clock register definitions were added for the majority of the relevant
> clocks inside the SoC.
> 
> Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
> ---
>  drivers/clk/samsung/clk-exynos5410.c |  231 +++++++++++++++++++++++++++++++++-
>  1 file changed, 228 insertions(+), 3 deletions(-)

Looks good, thanks. Since this patch depends on previous ones from this
series, I'll wait for next revision (+some time to let people see the
patches) before applying.

Best regards,
Tomasz
