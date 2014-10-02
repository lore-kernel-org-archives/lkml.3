Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaJBTIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:08:30 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55439 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaJBTI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:08:28 -0400
MIME-Version: 1.0
Date: Thu, 2 Oct 2014 21:08:26 +0200
X-Google-Sender-Auth: 7XatNh7z1Gd9T7QcCb_HnCWzL4g
Message-ID: <CAMuHMdWc1X3Jiw3zFs2GsqXKxg-Ti_5fPOSk+DsyUwjvikwz+g@mail.gmail.com>
Subject: cehckpatch config symbol description false positive
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, Joe,

When running checkpatch on
http://marc.info/?l=linux-sh&m=141227657322649&w=2
I get a false positive about the Kconfig symbol I just introduced, incl. a help
text:

WARNING: please write a paragraph that describes the config symbol fully
#60: FILE: arch/arm/Kconfig.debug:702:
+ config DEBUG_SCIF

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
