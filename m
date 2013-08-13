Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab3HMHTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:19:14 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14065 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab3HMHTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:19:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Aug 2013 00:17:15 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>, <sameo@linux.intel.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <rob@landley.net>, <lee.jones@linaro.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <j-keerthy@ti.com>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/3] regulator: palams: add support for external control of rail
Date: Tue, 13 Aug 2013 13:03:42 +0530
Message-ID: <1376379225-10604-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the enable/disable of the Palmas regulators to be controlled by
external input signals ENABLE1, ENABLE2 and NSLEEP.

The change is generated on top of
[PATCH v4] regulator: palmas: model SMPS10 as two regulators
by Kishone.

I think it should go on regulator tree if it is fine after review.

Laxman Dewangan (3):
  regulator: palmas: Update the DT binding doc for smps10 out1 and out2
  mfd: palmas: add support for external control configuration
  regulator: palmas: add support for external control of rails

 .../devicetree/bindings/regulator/palmas-pmic.txt  |   12 +-
 drivers/mfd/palmas.c                               |   97 ++++++++++++++
 drivers/regulator/palmas-regulator.c               |  139 +++++++++++++++++++-
 include/linux/mfd/palmas.h                         |   49 +++++++
 4 files changed, 287 insertions(+), 10 deletions(-)

