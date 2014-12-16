Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLPK5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:57:21 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33674 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaLPK5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:57:20 -0500
MIME-Version: 1.0
In-Reply-To: <548F086B.3090607@gmail.com>
References: <548F086B.3090607@gmail.com>
Date: Tue, 16 Dec 2014 11:57:18 +0100
X-Google-Sender-Auth: RNDbqqcmLc36XmGjq_YIvJLYcOg
Message-ID: <CAMuHMdU1DQBcq5AiVYaT8m3b7x_HFa6SMy-KOw5m7W=S8LPrJw@mail.gmail.com>
Subject: Re: Cannot find jffs2_commit_write
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: nick <xerofoify@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Mon, Dec 15, 2014 at 5:12 PM, nick <xerofoify@gmail.com> wrote:
> I seem to not be able to locate jffs2_commit_write by searching with lxr. If someone can tell me what file the function is located in that would be greatly appreciated.

That's because it does not exist. Presumably someone forgot to update
an error message when it was renamed (before it entered mainline in ... 2002!

BTW, please clone Linus' git tree instead of lurking in lxr for real development
(I assume that's what you want to do? ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
