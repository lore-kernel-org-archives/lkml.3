Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaIAQvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:51:22 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64473 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIAQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <54046CA1.4040108@broadcom.com>
References: <1409329464-768-1-git-send-email-geert@linux-m68k.org>
	<54042CA1.6010904@broadcom.com>
	<CAMuHMdV2hV_r_OASkv+U-AGVov18qFOrAVm-nDHHPHXZ6fcxxg@mail.gmail.com>
	<54046CA1.4040108@broadcom.com>
Date: Mon, 1 Sep 2014 18:51:19 +0200
X-Google-Sender-Auth: -aZn_mXSN6iCvP0JZ7uF3pxfnfI
Message-ID: <CAMuHMdWEbyXmNyPW1Mubv+idYuqsqbVVKuGyML5=vJ+58iTZig@mail.gmail.com>
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

On Mon, Sep 1, 2014 at 2:54 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 09/01/14 10:44, Geert Uytterhoeven wrote:
>> On Mon, Sep 1, 2014 at 10:21 AM, Arend van Spriel<arend@broadcom.com>
>> wrote:
>>>>
>>>>    config BRCMFMAC
>>>>          tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
>>>> -       depends on CFG80211
>>>> +       depends on CFG80211A&&   HAS_DMA
>>>
>>> Not sure what happened here, but CFG80211 kconfig option did was not
>>> renamed
>>> as far as I know. Anyway, I would like to propose a different solution.
>>> Will get back to you when I have it ready.

> I added Kconfig options for the proto layer which are selected by the host
> interface selection. So the HAS_DMA dependency is checked for BRCMFMAC_PCIE.

Thanks!

> I am wondering whether GENERIC_IO should also be checked.

Probably not. Let's see if anyone complains ;-)

> Can you verify the patch below works with your configuration?

Yes, it compiles and links fine now (after applying it manually due to
whitespace mess-up).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
