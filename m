Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab3GUDOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 23:14:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34365 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3GUDOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 23:14:51 -0400
Message-ID: <51EB522A.8060203@wwwdotorg.org>
Date: Sat, 20 Jul 2013 21:14:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: generic: add simple card with devicetree support
References: <20130720192554.79b7061b@armhf>
In-Reply-To: <20130720192554.79b7061b@armhf>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2013 11:25 AM, Jean-Francois Moine wrote:
> This generic simple card driver uses DT values to instanciate an audio
> system in which the real work is done by the subdrivers (audio
> controller, audio codec and pcm/dma controller).

New DT bindings should be sent to devicetree@vger.kernel.org for review.
Note that's a branch new list (it moved from a different server), so it
might be best to wait a few days for people to subscribe before sending
mail to it.
