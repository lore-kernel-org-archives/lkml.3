Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092Ab3DPRn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:43:28 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:48747 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935536Ab3DPRn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:43:27 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Some kconfig improvements and fixes
Date: Tue, 16 Apr 2013 19:43:09 +0200
Message-Id: <1366134193-22030-1-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

Here is a short series with a few kconfig improvements and fixes:
  - fix in ncurses headers location
  - fix randconfig always selecting the first entry of a choice
  - enhance randconfig with user-suplied seed and/or probability

I'm posting this series for review before I send Michal a final
pull-request before the merge window opens for 3.10.

    [PATCH 1/4] kconfig/lxdialog: rationalise the include paths where to find {.n}curses{,w}.h
    [PATCH 2/4] kconfig: allow specifying the seed for randconfig
    [PATCH 3/4] kconfig: implement KCONFIG_PROBABILITY for randconfig
    [PATCH 4/4] kconfig: do randomise choice entries in presence of KCONFIG_ALLCONFIG

Regards,
Yann E. MORIN.
