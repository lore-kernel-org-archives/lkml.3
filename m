Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaAQW3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:29:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60414 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752734AbaAQW3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:29:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [GIT PULL] Last minute ACPI fix for v3.13
Date: Fri, 17 Jan 2014 23:43:39 +0100
Message-ID: <1607643.bXgUGr2Zse@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-3.13-fixup

to receive a last-minute ACPI fix for 3.13 as commit 
b40f93bb008ed5d83aa608b21c8c65c5111512e1

  Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"

on top of commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6

  Linux 3.13-rc8

This reverts a commit that causes the Alan Cox' ASUS T100TA to "crash and
burn" during boot if the Baytrail pinctrl driver is compiled in.

Thanks!


---------------

Rafael J. Wysocki (1):
      Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"

---------------

 drivers/acpi/acpi_lpss.c           | 1 -
 drivers/pinctrl/pinctrl-baytrail.c | 1 -
 2 files changed, 2 deletions(-)

