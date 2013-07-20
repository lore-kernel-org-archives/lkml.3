Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3GTUXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:23:23 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:36649 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3GTUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:23:21 -0400
Message-ID: <51EAF1C8.2070009@gmail.com>
Date: Sat, 20 Jul 2013 22:23:36 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH] ASoC: generic: add simple card with devicetree support
References: <20130720192554.79b7061b@armhf>
In-Reply-To: <20130720192554.79b7061b@armhf>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 20.07.2013 19:25, Jean-Francois Moine wrote:
> This generic simple card driver uses DT values to instanciate an audio
> system in which the real work is done by the subdrivers (audio
> controller, audio codec and pcm/dma controller).
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---

> diff --git a/sound/soc/generic/simple-dt-card.c b/sound/soc/generic/simple-dt-card.c
> new file mode 100644

There is a simple-card driver in the tree already, and there were
several attempts to add DT bindings for it in the past - have you seen
that? Search for "ASoC: add simple-card DT support" in the archives ...


Daniel

