Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab3CMHyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 03:54:09 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53233 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3CMHyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 03:54:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbozpAVNb+7QLhiiinC+MMERvA=vNFP5kZiWLnsiv7dpg@mail.gmail.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com> <CACRpkdbozpAVNb+7QLhiiinC+MMERvA=vNFP5kZiWLnsiv7dpg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 13 Mar 2013 15:53:45 +0800
X-Google-Sender-Auth: FqSu5ZeXFPRYEkhbuHt_ZldEfnI
Message-ID: <CACxGe6shiqqACd6S1VTEkno993xB+E7y2cLi3HOw6yUH+Mbn7A@mail.gmail.com>
Subject: Re: [RFC 00/17] Remove GENERIC_GPIO from architecture code
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 1:12 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Mar 12, 2013 at 11:12 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> This series makes sure the GENERIC_GPIO option can only be set through GPIOLIB
>> (and not by individual architectures), as a first step towards its removal.
>
> Nice!
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> I bet something will break, anyway: no pain no gain.

Since this is a pretty invasive patch series that touches a lot of
architectures, we should get it into a separate branch that can get
pulled into linux-next.

g.
