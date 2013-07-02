Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3GBPWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:22:24 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:61714 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331Ab3GBPWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:22:22 -0400
Message-ID: <51D2F0FA.6040409@metafoo.de>
Date: Tue, 02 Jul 2013 17:25:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        richard.genoud@gmail.com, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/2] ASoC: atmel_ssc_dai: move set dma data
 to startup callback
References: <1372755849-19546-1-git-send-email-voice.shen@atmel.com> <1372755849-19546-2-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1372755849-19546-2-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 11:04 AM, Bo Shen wrote:
[...]
> +	dma_params->substream = substream;

Unrelated to this patch, but having a substream field in the dma_params seems
to be redundant, since you need to know the substream to get the dma_params in
the first place. Looking at the code it also seems to be unused other than this
assignment. Maybe you can send a follow up patch to remove it.

[...]

