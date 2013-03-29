Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3C2IyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 04:54:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:24849 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3C2IyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 04:54:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [GIT PULL] at91: tiny cleanup for 3.10 #2
Date: Fri, 29 Mar 2013 09:54:10 +0100
Message-ID: <1364547250-19675-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

This is a one-line cleanup patch. I have made a pull-request anyway because
I do not want to mix it with my upcoming DT pull-request. I guess that you can
simply cherry-pick the patch if you want. It is based on material that you
already have in arm-soc/at91/cleanup branch.

Thanks, best regards,


The following changes since commit 9317960fa38ff50ac287904e4c751a169635ecbf:

  ARM: at91: renamme rm9200 dt file (2013-03-13 17:28:14 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup

for you to fetch changes up to e7619459d47a673af3433208a42f583af920e9db:

  ARM: at91: Fix typo in restart code panic message (2013-03-26 12:21:25 +0100)

----------------------------------------------------------------
Tiny one-line typo patch.

----------------------------------------------------------------
Maxime Ripard (1):
      ARM: at91: Fix typo in restart code panic message

 arch/arm/mach-at91/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
