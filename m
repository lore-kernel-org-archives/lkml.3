Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaIVNY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:24:28 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58432 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaIVNY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140922130026.GK3290@leverpostej>
References: <87ioo7c0g5.wl%kuninori.morimoto.gx@renesas.com>
	<539815E6.2050304@codethink.co.uk>
	<20140611165410.GK5099@sirena.org.uk>
	<CAMuHMdUT0hEBGbN+W-Oz5zJ0N8S2VDMndqtDO=EtWF3jG2MEew@mail.gmail.com>
	<20140611170233.GL5099@sirena.org.uk>
	<5398A53D.3020706@wwwdotorg.org>
	<20140611190444.GN5099@sirena.org.uk>
	<5398AB07.4040304@wwwdotorg.org>
	<87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>
	<878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>
	<20140922130026.GK3290@leverpostej>
Date: Mon, 22 Sep 2014 15:24:24 +0200
X-Google-Sender-Auth: KrQPjEyLrrzCDg8bM4061ShtMIg
Message-ID: <CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>
Subject: Re: [PATCH][resend] of: Add vendor 2nd prefix for Asahi Kasei Corp
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>, Simon <horms@verge.net.au>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Sep 22, 2014 at 3:00 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> Given all that, I think we should get rid of the "ak" prefix entirely,
> fix up the seaboard dts, and leave the legacy matching for "ak,ak8975"
> up to the i2c framework. However, that would imply deleting from
> vendor-prefixes.txt (if we want people to be warned on use of "ak"), and
> that's not a good precedent to set.

Instead of deleting, we can deprecate, like was done for powervr:

powervr PowerVR (deprecated, use img)

Still missing is an update for checkpatch to warn when a deprecated
vendor prefix is used.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
