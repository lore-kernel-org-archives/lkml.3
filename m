Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaIAJDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:03:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43778 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbaIAJDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:03:22 -0400
Date: Mon, 1 Sep 2014 10:03:20 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Inha Song <ideal.song@samsung.com>, broonie@kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v5 1/2] mfd: arizona: Add support for
	INn_Mode register control
Message-ID: <20140901090320.GA12043@opensource.wolfsonmicro.com>
References: <1409365639-5320-1-git-send-email-ideal.song@samsung.com> <1409365639-5320-2-git-send-email-ideal.song@samsung.com> <20140901083233.GC7374@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901083233.GC7374@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 09:32:33AM +0100, Lee Jones wrote:
> On Sat, 30 Aug 2014, Inha Song wrote:
> 
> > Some boards need to set the INn_MODE[1:0] register to change
> > the input signal patch. This wlf,inmode property is optional.
> > If present, values must be specified less than or equal to
> > the number of input singals. If values less than the number
> > of input signals, elements that has not been specifed are set
> > to 0 by default.
> > 
> > Example:
> >    - wlf,inmode = <2 0 2>;	/* IN1, IN3 use DMIC */
> > 
> > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/arizona-core.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> 
> That looks better.
> 
> Applied, thanks.
> 
> Charles,
>   Can you confirm your Reviewed-by for this version of the patch
>   please?

Yeah all looks fine to me.

Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
