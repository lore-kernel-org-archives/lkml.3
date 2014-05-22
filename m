Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaEVJVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:21:38 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50121 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbaEVJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:21:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140522085339.26279.83340.sendpatchset@w520>
References: <20140522085339.26279.83340.sendpatchset@w520>
Date: Thu, 22 May 2014 11:21:35 +0200
X-Google-Sender-Auth: oQISudW6aVrSn2K0cJHaR-QserM
Message-ID: <CAMuHMdW=UdR9sk_jBZu_14LvkHUqg+tXtGaFtLGD0+ikwqO+bw@mail.gmail.com>
Subject: Re: [PATCH 00/03] staging: Emma Mobile USB driver and KZM9D board code
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thanks for your series! This looks like a good solution for interim board
support.

On Thu, May 22, 2014 at 10:53 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> Olof, patch 3/3 contains some board staging code for KZM9D. As it is
> today the EMEV2 SoC is DT-only and we neither have defconfig nor Kconfig
> definitions for the KZM9D board (emev2-kzm9d.dts).

Although there's no KZM9D-specific defconfig anymore, support for it is
included in shmobile_defconfig, right?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
