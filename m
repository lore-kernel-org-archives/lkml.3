Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbbAMRpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:45:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32849 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbbAMRo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:44:58 -0500
Date: Tue, 13 Jan 2015 17:44:54 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Mark Brown <broonie@kernel.org>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ASoC: wm8904: fix runtime warning
Message-ID: <20150113174454.GV14516@opensource.wolfsonmicro.com>
References: <1421143531-6662-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421143531-6662-1-git-send-email-voice.shen@atmel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 06:05:31PM +0800, Bo Shen wrote:
> Correct the path name for mux to get rid of the following warning:
> 
> --->8---
> wm8904 1-001a: Control not supported for path ADCL -> [Left] -> AIFOUTL
> wm8904 1-001a: ASoC: no dapm match for ADCL --> Left --> AIFOUTL
> wm8904 1-001a: ASoC: Failed to add route ADCL -> Left -> AIFOUTL
> wm8904 1-001a: Control not supported for path ADCR -> [Right] -> AIFOUTL
> wm8904 1-001a: ASoC: no dapm match for ADCR --> Right --> AIFOUTL
> wm8904 1-001a: ASoC: Failed to add route ADCR -> Right -> AIFOUTL
> wm8904 1-001a: Control not supported for path ADCL -> [Left] -> AIFOUTR
> wm8904 1-001a: ASoC: no dapm match for ADCL --> Left --> AIFOUTR
> wm8904 1-001a: ASoC: Failed to add route ADCL -> Left -> AIFOUTR
> wm8904 1-001a: Control not supported for path ADCR -> [Right] -> AIFOUTR
> wm8904 1-001a: ASoC: no dapm match for ADCR --> Right --> AIFOUTR
> wm8904 1-001a: ASoC: Failed to add route ADCR -> Right -> AIFOUTR
> wm8904 1-001a: Control not supported for path AIFINR -> [Right] -> DACL
> wm8904 1-001a: ASoC: no dapm match for AIFINR --> Right --> DACL
> wm8904 1-001a: ASoC: Failed to add route AIFINR -> Right -> DACL
> wm8904 1-001a: Control not supported for path AIFINL -> [Left] -> DACL
> wm8904 1-001a: ASoC: no dapm match for AIFINL --> Left --> DACL
> wm8904 1-001a: ASoC: Failed to add route AIFINL -> Left -> DACL
> wm8904 1-001a: Control not supported for path AIFINR -> [Right] -> DACR
> wm8904 1-001a: ASoC: no dapm match for AIFINR --> Right --> DACR
> wm8904 1-001a: ASoC: Failed to add route AIFINR -> Right -> DACR
> wm8904 1-001a: Control not supported for path AIFINL -> [Left] -> DACR
> wm8904 1-001a: ASoC: no dapm match for AIFINL --> Left --> DACR
> wm8904 1-001a: ASoC: Failed to add route AIFINL -> Left -> DACR
> ---8<---
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
