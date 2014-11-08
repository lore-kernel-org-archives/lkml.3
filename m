Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaKHXXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 18:23:17 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39267 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaKHXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 18:23:16 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 8 Nov 2014 23:22:55 +0000
X-Google-Sender-Auth: REEmsu0L_0WN-wAT6daAQcoG4KY
Message-ID: <CACxGe6sskK4wFXwx=b0B9QyCP602h6vC4EZU-iEBuN0YE9bB2A@mail.gmail.com>
Subject: [GIT PULL] Devicetree bug fix for v3.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending; forgot to cc the mailing lists]

Hi Linus.

Please pull the following branch for a device tree bug fix.

Thanks,
g.

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux devicetree/merge

for you to fetch changes up to a87fa1d81a9fb5e9adca9820e16008c40ad09f33:

  of: Fix overflow bug in string property parsing functions
(2014-11-04 10:19:48 +0000)

----------------------------------------------------------------
Devicetree bugfix for v3.18

One buffer overflow bug that shouldn't be left around.

----------------------------------------------------------------
Grant Likely (1):
      of: Fix overflow bug in string property parsing functions

 drivers/of/base.c                           | 88 ++++++++---------------------
 drivers/of/selftest.c                       | 66 ++++++++++++++++++++--
 drivers/of/testcase-data/tests-phandle.dtsi |  2 +
 include/linux/of.h                          | 84 ++++++++++++++++++++++-----
 4 files changed, 154 insertions(+), 86 deletions(-)
