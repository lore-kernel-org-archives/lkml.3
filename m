Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaHROYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:24:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40219 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbaHROYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:24:00 -0400
Date: Mon, 18 Aug 2014 15:23:56 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v3 1/2] mfd: arizona: Add support for
	INn_Modec register control
Message-ID: <20140818142356.GC7556@opensource.wolfsonmicro.com>
References: <20140818200003.2ab8aca0@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818200003.2ab8aca0@songinha-Samsung-DeskTop-System>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 08:00:03PM +0900, Inha Song wrote:
> Some boards need to set the INn_MODE[1:0] register to change
> the input signal patch. This wlf,inmode property is optional.
> If present, values must be specified less than or equal to
> the number of input singals. If values less than the number
> of input signals, elements that has not been specifed are set
> to 0 by default.
> 
> Example:
>    - wlf,inmode = <2 0 2>;	/* IN1, IN3 use DMIC */
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---

Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
