Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbaGaQFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:05:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50194 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaGaQFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:05:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140731160538.4463.4718@quantum>
Subject: [GIT PULL] clk: fixes for 3.16, part 2
Date: Thu, 31 Jul 2014 09:05:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91:

  Linux 3.16-rc7 (2014-07-27 12:41:55 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-fixes-for-linus

for you to fetch changes up to a74c52def9ab953c77956a8e93d225621980f54c:

  clk: ti: clk-7xx: Correct ABE DPLL configuration (2014-07-31 08:36:58 -0700)

----------------------------------------------------------------
A single patch to re-enable audio which is broken on all DRA7 SoC-based
platforms. Missed this one from the last set of fixes.

----------------------------------------------------------------
Peter Ujfalusi (1):
      clk: ti: clk-7xx: Correct ABE DPLL configuration

 drivers/clk/ti/clk-7xx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
