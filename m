Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaKQJ6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:58:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37789 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbaKQJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:58:07 -0500
Date: Mon, 17 Nov 2014 09:58:01 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, "perex@perex.cz" <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/3] gpio: arizona: Add support for CS47L24
Message-ID: <20141117095801.GA25618@opensource.wolfsonmicro.com>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com> <20141111170432.GB25738@opensource.wolfsonmicro.com> <CACRpkdazkS0M6G_gNvfKayZdrU+BMhSSF9iJp=fZEbc=+jDKsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdazkS0M6G_gNvfKayZdrU+BMhSSF9iJp=fZEbc=+jDKsA@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 07:41:53AM +0100, Linus Walleij wrote:
> On Tue, Nov 11, 2014 at 6:04 PM, Richard Fitzgerald
> <rf@opensource.wolfsonmicro.com> wrote:
> 
> > Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> 
> Apart from the whitespace fix pointed out by Mark,

THe line Mark commented on isn't a whitespace error. It matches
the copyright line style used by Cirrus in other files.

> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Yours,
> Linus Walleij
