Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaIAIob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:44:31 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:32864 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaIAIo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:44:27 -0400
MIME-Version: 1.0
In-Reply-To: <54042CA1.6010904@broadcom.com>
References: <1409329464-768-1-git-send-email-geert@linux-m68k.org>
	<54042CA1.6010904@broadcom.com>
Date: Mon, 1 Sep 2014 10:44:25 +0200
X-Google-Sender-Auth: wkFI047FcD1wfLmNlWCXIcVQUJM
Message-ID: <CAMuHMdV2hV_r_OASkv+U-AGVov18qFOrAVm-nDHHPHXZ6fcxxg@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: BRCMFMAC should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list@broadcom.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arend,

On Mon, Sep 1, 2014 at 10:21 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>   config BRCMFMAC
>>         tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
>> -       depends on CFG80211
>> +       depends on CFG80211A&&  HAS_DMA
>
> Not sure what happened here, but CFG80211 kconfig option did was not renamed
> as far as I know. Anyway, I would like to propose a different solution. Will

Oops, that was me typing the vim append-command twice :-(
Thanks for noticing!

> get back to you when I have it ready.

OK. Thanks again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
