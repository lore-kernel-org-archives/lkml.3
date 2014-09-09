Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaIIVhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:37:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47054 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaIIVhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:37:01 -0400
Date: Tue, 9 Sep 2014 23:36:52 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Lee Jones <lee.jones@linaro.org>, Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, patrice.chotard@st.com,
        devicetree@vger.kernel.org
Subject: [GIT PULL v2] STiH407 reset controller support
Message-ID: <20140909213651.GA591@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 23:35:11 up 24 days,  9:55, 61 users,  load average: 0,24, 0,10,
 0,06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

I have rebased the STiH407 reset controller patches onto v3.17-rc1.
The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.pengutronix.de/git/pza/linux.git tags/reset-for-sti-3.18

for you to fetch changes up to a83a81838a294adbb5356e6b4a3adcda1439d98e:

  reset: sti: Document sti-picophyreset controllers bindings. (2014-09-04 13:05:01 +0200)

----------------------------------------------------------------
STiH407 reset controller support

----------------------------------------------------------------
Peter Griffin (2):
      reset: stih407: Add softreset, powerdown and picophy controllers
      reset: sti: Document sti-picophyreset controllers bindings.

 .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
 drivers/reset/sti/Kconfig                          |   4 +
 drivers/reset/sti/Makefile                         |   1 +
 drivers/reset/sti/reset-stih407.c                  | 158 +++++++++++++++++++++
 .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
 5 files changed, 266 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
 create mode 100644 drivers/reset/sti/reset-stih407.c
 create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h
