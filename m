Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3FYKNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:13:54 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42539 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3FYKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:13:53 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 25 Jun 2013 12:13:52 +0200
Message-ID: <CA+icZUUx6DucHU98+iXzOT7rnUce=YW=FNtjMjFZkWY9DOmGtA@mail.gmail.com>
Subject: No mure funny release-names ($NAME) in Makefile?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

AFAICS the funny release-names ($NAME) have not changed for a long
while (did not check the logs).
Is that now useless...

L#5: NAME = Unicycling Gorilla

... or you lost all creativity in your brain :-)?

If I look at the xserver folks, they do change it for even rc#s...
(too much creativity, maybe).

( Background of my asking was a refresh of [2]. )

Regards,
- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Makefile#n5
[2] http://freetz.org/browser/trunk/tools/make/patches/300-main_makefile.kconfig.patch
