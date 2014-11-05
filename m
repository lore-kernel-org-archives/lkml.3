Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaKELOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:14:50 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:62033 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaKELOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:14:49 -0500
MIME-Version: 1.0
In-Reply-To: <1415185699-28292-1-git-send-email-geert@linux-m68k.org>
References: <1415185699-28292-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 5 Nov 2014 12:14:46 +0100
X-Google-Sender-Auth: 5vFEBrfohmX73yJQ0_wX-vNX3Fg
Message-ID: <CAMuHMdXVniq3oNwdaXRgj3GG3STbncAQfam03poNnGkEe8XPpA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.18-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 12:08 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.18-rc3[1]  to v3.18-rc2[3], the summaries are:
>   - build errors: +5/-21

  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
(near initialization for ‘virtblk_dev_page.blk_config.capacity’):  =>
152:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
(near initialization for ‘virtblk_dev_page.blk_config.seg_max’):  =>
151:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
(near initialization for ‘virtblk_dev_page.host_features’):  => 149:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
(near initialization for ‘virtnet_dev_page.host_features’):  => 119:3

sh-randconfig

  + /home/kisskb/slave/src/net/bridge/netfilter/nft_reject_bridge.c:
error: implicit declaration of function 'csum_ipv6_magic'
[-Werror=implicit-function-declaration]:  => 240:3

s390-allyesconfig
s390-allmodconfig
cris-allyesconfig
cris-allmodconfig
powerpc-allyesconfig
powerpc-allmodconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/8044/ (120 out of 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8016/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
