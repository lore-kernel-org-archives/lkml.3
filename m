Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbbATPqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:46:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48165 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849AbbATPqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:46:15 -0500
Date: Tue, 20 Jan 2015 15:46:11 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, lee.jones@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel] [PATCH v2 RESEND 1/2] mfd: arizona: Add support
	for OUTn_MONO register control
Message-ID: <20150120154611.GA14516@opensource.wolfsonmicro.com>
References: <1420185829-24886-1-git-send-email-ideal.song@samsung.com> <1420185829-24886-2-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420185829-24886-2-git-send-email-ideal.song@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 05:03:48PM +0900, Inha Song wrote:
> Some boards need to set the OUTn_MONO register to configurates
> the output signal path as a mono differential output. This
> wlf,out-mono property is optional. If present, values must be
> specified less than or equal to the number of output signals.
> If values less than the number of output signals, elements
> that has not been specified are set to 0 by default.
> 
> Example:
>  - wlf,out-mono = <1 0 1>; /* set OUT1,OUT3 to mono differential */
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---

Apologies, I must have missed this in the December rush here.

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
