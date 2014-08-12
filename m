Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaHLNfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 09:35:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50941 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbaHLNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 09:35:01 -0400
Date: Tue, 12 Aug 2014 14:34:58 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: rf@opensource.wolfsonmicro.com, lee.jones@linaro.org,
        sameo@linux.intel.com, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v4 RESEND] ASoC: arizona: Add DVFS handling for
	sample rate control
Message-ID: <20140812133458.GD15833@opensource.wolfsonmicro.com>
References: <20140808133233.GA2665@opensource.wolfsonmicro.com> <20140808133510.GC2665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808133510.GC2665@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 02:35:10PM +0100, Richard Fitzgerald wrote:
> From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> 
> Some codecs need to boost DVFS for higher sample rates.
> 
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---

Hi Mark,

Would it be possible to get an Ack for the ASoC patches here, Lee
said it would be ok to put the series through the MFD tree once
we have an ack? Unless you have any issues with the series?

Thanks,
Charles
