Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbbAZOyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:54:55 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:33619 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbbAZOyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:54:47 -0500
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        peda@axentia.se
Cc: Sylvain Rochet <sylvain.rochet@finsecur.com>
Date: Mon, 26 Jan 2015 15:54:38 +0100
Message-Id: <1422284080-32446-1-git-send-email-sylvain.rochet@finsecur.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422265068-22974-1-git-send-email-wenyou.yang@atmel.com>
References: <1422265068-22974-1-git-send-email-wenyou.yang@atmel.com>
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: [PATCH v2 0/2] pm: at91: pm_slowclock: improve reliability of suspend/resume
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
  * I only splitted my patch in two

Sylvain Rochet (2):
  pm: at91: pm_slowclock: fix suspend/resume hang up in timeouts
  pm: at91: pm_slowclock: remove clocks which are already stopped when
    entering slow clock mode

 arch/arm/mach-at91/pm.c           | 12 ++++++++
 arch/arm/mach-at91/pm_slowclock.S | 62 ++-------------------------------------
 2 files changed, 15 insertions(+), 59 deletions(-)

-- 
2.1.4

