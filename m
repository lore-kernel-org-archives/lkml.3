Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaFQWyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:54:01 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51412 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbaFQWx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:53:59 -0400
MIME-Version: 1.0
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 17 Jun 2014 17:53:37 -0500
Message-ID: <CAL_Jsq+Xje_=M_ExuGkw63mp0N5AWaWiDaRjWK9gzP5j53zNAA@mail.gmail.com>
Subject: [GIT PULL] DeviceTree fixes for 3.16
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a few small DT fixes for 3.16.

Rob

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/dt-fixes-for-3.16

for you to fetch changes up to 99de64984c3a7c9bf56a50e6dcc51006c9485620:

  OF: fix of_find_node_by_path() assumption that of_allnodes is root
(2014-06-16 13:31:44 -0500)

----------------------------------------------------------------
- Fix microblaze compiling due to conflicting merge window changes
- A fix in of_attach_node due to of_find_node_by_path changes
- Prevent format strings in DT kobject names

----------------------------------------------------------------
Frank Rowand (1):
      OF: fix of_find_node_by_path() assumption that of_allnodes is root

Guenter Roeck (1):
      of/platform: Fix microblaze build failure

Kees Cook (1):
      of: avoid format string parsing in kobject names

 drivers/of/base.c     | 7 ++++---
 drivers/of/platform.c | 4 ----
 2 files changed, 4 insertions(+), 7 deletions(-)
