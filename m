Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbbA0WGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:06:35 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65088 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759895AbbA0WGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:06:33 -0500
MIME-Version: 1.0
In-Reply-To: <54C8029A.5080500@linicks.net>
References: <54C8029A.5080500@linicks.net>
Date: Tue, 27 Jan 2015 23:06:32 +0100
X-Google-Sender-Auth: -sEea0LFPAx4OmOQfJWmURGm9F4
Message-ID: <CAMuHMdUPKMt7x2F=G6eua_D1BRnHzXhgTMzs4Koi6ZLSxf+ZJA@mail.gmail.com>
Subject: Re: Linux 3.18.4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nick Warne <nick@linicks.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 10:26 PM, Nick Warne <nick@linicks.net> wrote:
> So, I just updated my lowly Samsung notebook bespoke build - normal build
> time on this is about 57 minutes - 3.18.4 is now < 45 minutes.

Do you use ccache? If not, you should.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
