Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab3JNF2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:28:44 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:35231 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750806Ab3JNF2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:28:43 -0400
Message-ID: <525B8105.6090303@atmel.com>
Date: Mon, 14 Oct 2013 13:28:37 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4/4] sound/soc/atmel: don't use devm_pinctrl_get_select_default()
 in probe
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de> <1381681071-6021-5-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1381681071-6021-5-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram Sang,

On 10/14/2013 00:17, Wolfram Sang wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>   sound/soc/atmel/atmel_wm8904.c | 8 --------
>   1 file changed, 8 deletions(-)

Tested OK on at91sam9n12ek and sama5d3xek board.
Thanks.

Acked-by: Bo Shen <voice.shen@atmel.com>

Best Regards,
Bo Shen
