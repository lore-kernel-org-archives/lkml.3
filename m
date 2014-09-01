Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaIAQ5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:57:33 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:32964 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIAQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:57:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140901132808.c7b08f4ffa7055dc28e6dac7@kernel.org>
References: <20140901132808.c7b08f4ffa7055dc28e6dac7@kernel.org>
Date: Mon, 1 Sep 2014 18:57:29 +0200
X-Google-Sender-Auth: 0n4OLYmzB_hgJqmolveqc_xjD24
Message-ID: <CAMuHMdXmP8v3Grj=0Qay9eZ+zkWYTZAe4Qy+T8zJq=NDFU9tjQ@mail.gmail.com>
Subject: Re: linux-next: jdelvare-hwmon tree unfetchable
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>, Jean Delvare <jdelvare@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>, Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC jean @ suse

On Mon, Sep 1, 2014 at 2:28 PM, Mark Brown <broonie@kernel.org> wrote:
> Today's linux-next merge of the jdelvare-hwmon tree got a conflict with Linus'
> tree which appeared to be due to the hwmon quilt series I got from Stephen being
> based on v3.14-rc3 and subsequent changes from mainline interacting badly with
> it. In addition I'm not able to check the original series since linux-fr.org does
> not resolve for me.

Same here. The domain exists, and seems to have been updated yesterday,
possibly breaking it?

> I'm really confused by what's going on here so I skipped the tree for today.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
