Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaHRVem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:34:42 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45178 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaHRVek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:34:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV_vAPCPh1JdCxtf0iz6haHULUV8t0oYt0jrEAky2WSLw@mail.gmail.com>
References: <1408396422-32658-1-git-send-email-bobby.prani@gmail.com>
 <1408396422-32658-2-git-send-email-bobby.prani@gmail.com> <CAMuHMdV_vAPCPh1JdCxtf0iz6haHULUV8t0oYt0jrEAky2WSLw@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 18 Aug 2014 17:34:08 -0400
Message-ID: <CAJhHMCACe=7uLEAFsoOvHUGALpSE0+5SCpiFqRQN8WhW3m3hOA@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix build error for vga16fb
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>, Jean Delvare <jdelvare@suse.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@linaro.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 5:28 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:

> Digging a bit deeper: There's no code left in arch/powerpc that actually
> sets vgacon_remap_base, so it's not gonna work anyway.
> It seems vga16 support on PPC died with the removal of arch/ppc/.

OK. I will remove the dependency on PPC for vga16fb.

-- 
Pranith
