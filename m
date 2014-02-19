Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaBSGaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:30:12 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51168 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaBSGaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:30:09 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org
Subject: [PATCH V2 0/2] Add support for clocks in S5M8767
Date: Wed, 19 Feb 2014 11:54:34 +0530
Message-Id: <1392791076-28301-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S5M8767 chip has 3 crystal oscillators which are operated in the same
as the crystal oscillators in S2MPS11. Extend s2mps11-clk driver to
support clocks in S5M8767.

The patches are rebased on top of next-20130218.

Tushar Behera (2):
  clk: clk-s2mps11: Refactor for including support for other MFD clocks
  clk: clk-s2mps11: Add support for clocks in S5M8767 MFD

 drivers/clk/Kconfig       |    6 ++++--
 drivers/clk/clk-s2mps11.c |   25 +++++++++++++++++++++----
 2 files changed, 25 insertions(+), 6 deletions(-)

-- 
1.7.9.5

