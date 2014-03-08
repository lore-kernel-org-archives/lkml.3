Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaCHDSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:18:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47896 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaCHDSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:18:03 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140308031755.12081.31683@quantum>
Subject: [GIT PULL] clk: fixes for 3.14, part 2
Date: Fri, 07 Mar 2014 19:17:55 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to d9120198ddef2c0b61ca6659ace41b7c1e7c8f08:

  clk: shmobile: rcar-gen2: Use kick bit to allow Z clock frequency change (2014-03-05 22:41:15 -0800)

----------------------------------------------------------------
Single fix for a clock driver merged in 3.14-rc1. Without this fix the
CPU frequency cannot be scaled.

----------------------------------------------------------------
Benoit Cousson (1):
      clk: shmobile: rcar-gen2: Use kick bit to allow Z clock frequency change

 drivers/clk/shmobile/clk-rcar-gen2.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)
