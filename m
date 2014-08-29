Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaH2TYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:24:22 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:45812 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbaH2TYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:24:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXahUGQ1-4SvkCnt=BrAn6_Xge7RzieR2K8gDmj_pC-kw@mail.gmail.com>
References: <1409329464-768-1-git-send-email-geert@linux-m68k.org>
	<5400C3E8.9040500@broadcom.com>
	<CAMuHMdXahUGQ1-4SvkCnt=BrAn6_Xge7RzieR2K8gDmj_pC-kw@mail.gmail.com>
Date: Fri, 29 Aug 2014 21:24:18 +0200
X-Google-Sender-Auth: qvoCVOauK-s0bkQzlSsmT19ukXI
Message-ID: <CAMuHMdVu=OSPw5WHBvWG_1ThAumfC3rOApPQ077wT_QPtxmegw@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: BRCMFMAC should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Franky Lin <frankyl@broadcom.com>
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

On Fri, Aug 29, 2014 at 9:23 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> but then it still failed to link. Hence I restored to the main BRCMFMAC.

s/restored/resorted/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
