Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbbAUUOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:14:18 -0500
Received: from smtp-out-067.synserver.de ([212.40.185.67]:1132 "EHLO
	smtp-out-067.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbbAUUOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:14:10 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13268
Message-ID: <54C0088F.9070609@metafoo.de>
Date: Wed, 21 Jan 2015 21:14:07 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC: devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jyri Sarha <jsarha@ti.com>
Subject: Re: [alsa-devel] [PATCH v2 3/3] ASoC: add generic dt-card support
References: <cover.1421868426.git.moinejf@free.fr> <d0c66c2e2f200119f9990fa52a503b1a4af6238f.1421868426.git.moinejf@free.fr>
In-Reply-To: <d0c66c2e2f200119f9990fa52a503b1a4af6238f.1421868426.git.moinejf@free.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> +	card->dai_link->dai_fmt =
> +		snd_soc_of_parse_daifmt(of_cpu, "dt-audio-card,",
> +					NULL, NULL) &
> +			~SND_SOC_DAIFMT_MASTER_MASK;


This one does not seem to be in the bindings documentation.

