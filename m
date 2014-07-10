Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaGJJVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:21:35 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:50747 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaGJJVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:21:32 -0400
MIME-Version: 1.0
In-Reply-To: <53BD2509.6070803@codethink.co.uk>
References: <cover.1404665589.git.himangi774@gmail.com>
	<1a1752ce7455bac8f2505a9790da891a830699f5.1404665589.git.himangi774@gmail.com>
	<53BD2509.6070803@codethink.co.uk>
Date: Thu, 10 Jul 2014 11:21:32 +0200
Message-ID: <CACRpkdZWfYN14aki-UqvWp1K0exVj-mMK92q431QueSVvjZFuA@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpiolib: devres: Introduce the function devm_request_gpio_array
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        patches@opensource.wolfsonmicro.com,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 1:18 PM, Rob Jones <rob.jones@codethink.co.uk> wrote:

> Please note that I submitted a patch on 02/07/14 to create this
> function which was acked by Linus Walleij on 05/07/14.
>
> Great minds think alike, and all that.

My mind certainly isn't any great :-(

My left hand seems to be unaware of what the right hand is doing.

Did I ACK that for merging through some other tree then?

And I guess if Himangi want to submit these ASoC patches, they
will have to go through the same tree as those patches in that case?

And would you consider implementing a gpiod version...?

> However, I think that the version I submitted better replicates the
> original (non devm) functionality, see below.
>
> I didn't, however, add it to the documentation. +1 on that.

Can you include that oneliner in your patch then to reduce
problems?

Yours,
Linus Walleij
