Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBJM6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:58:36 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58877 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbaBJM6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:58:33 -0500
MIME-Version: 1.0
In-Reply-To: <8438484.DB7cn7tjVR@avalon>
References: <1392029254-15400-1-git-send-email-geert@linux-m68k.org>
	<1392029254-15400-2-git-send-email-geert@linux-m68k.org>
	<8438484.DB7cn7tjVR@avalon>
Date: Mon, 10 Feb 2014 13:58:32 +0100
X-Google-Sender-Auth: 5JlT64U9fig98x5OQhoFJBpFHMQ
Message-ID: <CAMuHMdXAhZ0i4NcpymGADfN3wwxRZxpcwRVQEqsqpoGw_O0_Ug@mail.gmail.com>
Subject: Re: [PATCH 1/7] pinctrl: sh-pfc: r8a7790: Add QSPI pin groups
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 1:48 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> @@ -4212,6 +4244,7 @@ static const struct sh_pfc_function pinmux_functions[]
>> = { SH_PFC_FUNCTION(msiof0),
>>       SH_PFC_FUNCTION(msiof1),
>>       SH_PFC_FUNCTION(msiof2),
>> +     SH_PFC_FUNCTION(qspi),
>>       SH_PFC_FUNCTION(msiof3),
>
> I believe qspi comes after msiof3 :-)

Doh... silly me...

> Apart from that the patch looks good.
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
