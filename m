Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab3FSIqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:46:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16169 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914Ab3FSIqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:46:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 19 Jun 2013 01:45:45 -0700
Date: Wed, 19 Jun 2013 11:45:42 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Paul Walmsley <pwalmsley@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Aleksandr Frid <afrid@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
Message-ID: <20130619084542.GB3847@tbergstrom-lnx.Nvidia.com>
References: <20130607121505.21868.72360.stgit@dusk.lan>
 <20130607121901.21868.65416.stgit@dusk.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130607121901.21868.65416.stgit@dusk.lan>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 02:19:09PM +0200, Paul Walmsley wrote:
> Add DFLL DVCO reset line control functions to the CAR IP block driver.
> 
> The DVCO present in the DFLL IP block has a separate reset line,
> exposed via the CAR IP block.  This reset line is asserted upon SoC
> reset.  Unless something (such as the DFLL driver) deasserts this
> line, the DVCO will not oscillate, although reads and writes to the
> DFLL IP block will complete.
> 
> Thanks to Aleksandr Frid <afrid@nvidia.com> for identifying this and
> saving hours of debugging time.
> 
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Aleksandr Frid <afrid@nvidia.com>
> Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
Reviewed-by: <pdeschrijver@nvidia.com>

Cheers,

Peter.
