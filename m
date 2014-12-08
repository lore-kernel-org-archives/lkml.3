Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaLHKPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:15:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53633 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbaLHKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:15:33 -0500
Date: Mon, 8 Dec 2014 10:15:29 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <B50113@freescale.com>
Cc: Mark Brown <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel][PATCH v3] ASoC: wm8960: Let wm8960 codec driver
	manage its own MCLK
Message-ID: <20141208101529.GD14516@opensource.wolfsonmicro.com>
References: <1417696879-15402-1-git-send-email-b50113@freescale.com> <20141205170156.GB14516@opensource.wolfsonmicro.com> <20141205173932.GN11764@sirena.org.uk> <BN3PR0301MB12511B448B1C0B9E8F0BB6C48D640@BN3PR0301MB1251.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN3PR0301MB12511B448B1C0B9E8F0BB6C48D640@BN3PR0301MB1251.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 09:49:51AM +0000, Zidan Wang wrote:
> So I should move mclk to wm8960_priv. 
> And doing wm8960_priv->mclk = devm_clk_get(&i2c->dev, "codec_mclk") in wm8960_i2c_probe.
> 
> Best Regards,
> Zidan
> 
> -----Original Message-----

>From the sounds of Mark's comment I believe he is happy with it
where it is, and if he is happy so am I.

Thanks,
Charles
