Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab3IAOsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 10:48:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:63882 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab3IAOsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 10:48:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1001,1367996400"; 
   d="scan'208";a="389601129"
Date: Sun, 1 Sep 2013 16:48:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        alsa-devel@alsa-project.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Remove ASoC-level I/O functions from cq93vc
Message-ID: <20130901144847.GM20329@zurbaran>
References: <20130831130741.GG18608@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831130741.GG18608@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Aug 31, 2013 at 02:07:41PM +0100, Mark Brown wrote:
> This patch series removes the use of the ASoC-level read and write
> functions from the cq93vc driver as part of a wider push to remove them
> completely and just use regmap for all register I/O.  Since the driver
> is essentially doing what regmap-mmio is doing this is done by adding a
> MMIO regmap to the core device and using that.  This is compile tested
> only, I don't have any hardware to run on.
> 
> Since I anticipate doing more cleanups over the CODEC drivers during the
> next release cycle it'd be good to merge via ASoC, though there
> shouldn't be any overlap with the first patch.
As I'd prefer to carry the MFD ones (Including the twl6040 one) through
mfd-next, I can build a branch for you to pull from. Would that be fine
with you ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
