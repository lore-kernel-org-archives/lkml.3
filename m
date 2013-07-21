Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3GULaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 07:30:19 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35009 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3GULaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 07:30:17 -0400
Message-ID: <51EBC661.1080104@gmail.com>
Date: Sun, 21 Jul 2013 13:30:41 +0200
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
References: <20130720192554.79b7061b@armhf> <51EAF1C8.2070009@gmail.com> <20130721132405.5de01d32@armhf>
In-Reply-To: <20130721132405.5de01d32@armhf>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.07.2013 13:24, Jean-Francois Moine wrote:
> On Sat, 20 Jul 2013 22:23:36 +0200
> Daniel Mack <zonque@gmail.com> wrote:
> 
>> There is a simple-card driver in the tree already, and there were
>> several attempts to add DT bindings for it in the past - have you seen
>> that? Search for "ASoC: add simple-card DT support" in the archives ...
> 
> Hi Daniel,
> 
> Thanks, that is what I was searching.
> 
> I will wait for Kuninori.

Well, Kuninori recently stated he's currently too busy to continue.
Given his permission, it might be an option to pick up where he left off
and finish the open topics. Depends on how urgent your need is I guess.


Thanks,
Daniel

