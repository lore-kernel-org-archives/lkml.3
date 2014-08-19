Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaHSLlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:41:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43376 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbaHSLlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:41:20 -0400
Date: Tue, 19 Aug 2014 12:41:16 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v4 2/2] mfd: arizona: Update DT binding to
	support INn_MODE init_data
Message-ID: <20140819114116.GF7556@opensource.wolfsonmicro.com>
References: <20140819201407.3447715e@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819201407.3447715e@songinha-Samsung-DeskTop-System>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:14:07PM +0900, Inha Song wrote:
> This patch update DT binding to support INn_MODE init_data. Each
> input signal path can be configurated either as a Analogue or
> Digital using the INn_MODE registers.
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---

Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
