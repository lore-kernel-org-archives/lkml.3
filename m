Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab3EQWCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:02:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52583 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab3EQWCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 18:02:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130508154805.GA12970@balto.lan>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
	<1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
	<20130508105124.GA7478@sirena.org.uk>
	<20130508114216.GB29130@balto.lan>
	<20130508123225.GK7478@sirena.org.uk>
	<20130508131020.GA30503@balto.lan>
	<20130508135413.GR7478@sirena.org.uk>
	<20130508141723.GA12155@balto.lan>
	<20130508142938.GS7478@sirena.org.uk>
	<20130508154805.GA12970@balto.lan>
Date: Sat, 18 May 2013 00:02:18 +0200
Message-ID: <CACRpkdbZ4Wxx7qsyYOfFES-UpTTcRcfV6GZi-R8YmxhC-sLV8g@mail.gmail.com>
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 5:48 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Wed, May 08, 2013 at 03:29:38PM +0100, Mark Brown wrote:

>> It seems like the code is definitely buggy here but is this really all
>> that's buggy or is it just the symptom you happen to have seen?
>
> For the pinctrl code drop I still think that it should go, but really
> I leave the last word to LinusW as suggested.

Kill it then.

At the time the driver was upstreamed, it was using the old
nmk_config_pins() interface to switch the pins.

All I did was convert them to use pinctrl. See commit
08d98fe0e81cd9424ef2451ed13afe91a9a26f9f

If nobody knows why it was doing that in the first place, let's
just kill it.

Yours,
Linus Walleij
