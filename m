Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161991Ab3DEQGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:06:46 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:49934 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161964Ab3DEQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:06:44 -0400
MIME-Version: 1.0
In-Reply-To: <s5hzjxd2zec.wl%tiwai@suse.de>
References: <s5hzjxd2zec.wl%tiwai@suse.de>
Date: Fri, 5 Apr 2013 09:06:43 -0700
X-Google-Sender-Auth: DsqgUXeonV7blwaFb1WyxejdvXw
Message-ID: <CA+55aFzeB+75fSQZzqiNdN7JdcNd0qAxWeZuCm9h8Znh+wdZ3A@mail.gmail.com>
Subject: Re: [GIT PULL] Sound fixes for 3.9-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 12:46 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> please pull sound fixes for v3.9-rc6 from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git for-linus

Argh, Takashi, you're usually so reliable...

But you actually meant for me to pull the sound-3.9 tag, didn't you?
That "for-linus" branch isn't a signed tag..

Please double-check your scripts,

           Linus
