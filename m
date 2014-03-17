Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaCQK1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:27:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40198 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbaCQK1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:27:30 -0400
Message-ID: <5326CE04.2090504@ti.com>
Date: Mon, 17 Mar 2014 12:27:16 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Mark Brown <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        Xiubo Li <Li.Xiubo@freescale.com>, <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v3 2/4] ASoC: simple-card: dynamically allocate
 the DAI link and properties
References: <cover.1394883134.git.moinejf@free.fr>	<1cf50fea2306bcb05987533042dbf1495b2c6f07.1394883134.git.moinejf@free.fr>	<5326C086.6080609@ti.com> <20140317112332.4a0700d8@armhf>
In-Reply-To: <20140317112332.4a0700d8@armhf>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 12:23 PM, Jean-Francois Moine wrote:
> Jyri,
>
> No, this would not work. The DAI link in the struct snd_soc_card is an
> array of struct snd_soc_dai_link. There cannot be anything between the
> elements!

Oh.. did not go deep enough. Forget about this comment.

Best regards,
Jyri
