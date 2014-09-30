Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaI3M2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:28:47 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:40538 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaI3M2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <1412079396-26005-1-git-send-email-thibaut.robert@gmail.com>
References: <1412079396-26005-1-git-send-email-thibaut.robert@gmail.com>
Date: Tue, 30 Sep 2014 14:28:43 +0200
X-Google-Sender-Auth: -g26A-iLmbsVbjhkoLAXWlJCHak
Message-ID: <CAMuHMdXj=b0G7foTRkcEtRC_De8+WjVefxBfW=s1sjaXLeF5nQ@mail.gmail.com>
Subject: Re: [PATCH] tc: fix warning and coding style
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thibaut Robert <thibaut.robert@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thibaut,

On Tue, Sep 30, 2014 at 2:16 PM, Thibaut Robert
<thibaut.robert@gmail.com> wrote:
> Fix gcc warning:
> warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘resource_size_t’ [-Wformat=]
>
> As resource_size_t can be 32 or 64 bits (depending on CONFIG_RESOURCES_64BIT), this patch uses "%lld" format along with a cast to u64 for printing resource_size_t values

Please use %pR instead (cfr. Documentation/printk-formats.txt).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
