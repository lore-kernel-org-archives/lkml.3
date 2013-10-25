Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3JYSEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:04:38 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56774 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3JYSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:04:36 -0400
MIME-Version: 1.0
In-Reply-To: <20131025171721.GB8091@roeck-us.net>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
	<5269FB5E.6010901@roeck-us.net>
	<20131025083525.GF19622@ulmo.nvidia.com>
	<CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
	<20131025133512.GA1551@ulmo.nvidia.com>
	<CAOesGMh=VLEuFgZuwrJnPsbxnr1Y528CVUdq313Ey5SVUb-jsw@mail.gmail.com>
	<20131025141707.GA27461@ulmo.nvidia.com>
	<20131025150228.GA5501@roeck-us.net>
	<20131025151717.GA3782@ulmo.nvidia.com>
	<20131025171721.GB8091@roeck-us.net>
Date: Fri, 25 Oct 2013 20:04:36 +0200
X-Google-Sender-Auth: DGTpa3NN8YyPHArd_Mmg3zoJ3n4
Message-ID: <CAMuHMdWMQxpJfRm+wTun0dgiex3WNPwqKOf4EimfqQOnfUrbJQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 24
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Thierry Reding <thierry.reding@gmail.com>, Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 7:17 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> I think one problem we have is how to report breakages. Any summary
> mail or web page doesn't help if no one looks at it. It does help lot
> to send specific e-mail along the line of "Commit 'bla' caused build 'x'
> to fail as follows" to the respective mailing list and patch authors,
> but that takes a lot of time which at least I don't have. And people
> might get annoyed by automated e-mails, so that might not be a good
> idea either.

In theory, these blame emails can be automated using some git bisect
scripting.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
