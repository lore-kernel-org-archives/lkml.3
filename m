Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbbAFJOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:14:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44729 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbbAFJOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:14:50 -0500
Date: Tue, 6 Jan 2015 09:14:48 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 8/8] ASoC: wm8804: Constify struct regmap_config and
	snd_soc_codec_driver
Message-ID: <20150106091448.GM14516@opensource.wolfsonmicro.com>
References: <1420449508-10701-1-git-send-email-k.kozlowski@samsung.com> <1420449508-10701-8-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420449508-10701-8-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 10:18:28AM +0100, Krzysztof Kozlowski wrote:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make struct
> snd_soc_codec_driver (snd_soc_register_codec() accepts pointer to const)
> and array of default register values const as well.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: patches@opensource.wolfsonmicro.com
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
