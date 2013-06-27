Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3F0Gtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:49:47 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48271 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3F0Gtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:49:46 -0400
MIME-Version: 1.0
In-Reply-To: <51CB745B.4060604@uclinux.org>
References: <1372189212-12136-1-git-send-email-geert@linux-m68k.org>
	<51CB745B.4060604@uclinux.org>
Date: Thu, 27 Jun 2013 08:49:45 +0200
X-Google-Sender-Auth: NiyoSA780M2lBlCXYqO2a9yhVD8
Message-ID: <CAMuHMdV2XakPGZP5gYygBPgg+DeSRj7qP6hF7T6nN-OQKTodtA@mail.gmail.com>
Subject: Re: [PATCH] m68knommu: Mark config_BSP() __init
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>
Cc: uClinux development list <uclinux-dev@uclinux.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 1:08 AM, Greg Ungerer <gerg@uclinux.org> wrote:
> On 26/06/13 05:40, Geert Uytterhoeven wrote:
>>
>> Some instances of config_BSP() lack an __init annotation.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
>
> Acked-by: Greg Ungerer <gerg@uclinux.org>
>
> Looks good. Are you going to push it via your tree, or do you want
> me too?

As it's m68nommu, perhaps through your tree? Unless you don't have time to
handle it.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
