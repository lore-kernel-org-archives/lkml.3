Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbbATPtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:49:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48188 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbbATPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:49:23 -0500
Date: Tue, 20 Jan 2015 15:49:22 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, lee.jones@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel] [PATCH v2 RESEND 2/2] mfd: arizona: Update DT
	binding to support OUTn_MONO init_data
Message-ID: <20150120154922.GB14516@opensource.wolfsonmicro.com>
References: <1420185829-24886-1-git-send-email-ideal.song@samsung.com> <1420185829-24886-3-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420185829-24886-3-git-send-email-ideal.song@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 05:03:49PM +0900, Inha Song wrote:
> This patch update DT binding to support OUTn_MONO init_data. Each
> output signal can be configurated as a mono differential output.
> The mono differential configuration is selected using the OUTn_MONO
> registers.
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---

Agree with Lee an example probably would be nice. But otherwise
this looks fine.

Thanks,
Charles
