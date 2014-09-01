Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaIACkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:40:45 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63244 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaIACko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:40:44 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: lgirdwood@gmail.com, broonie@kernel.org
Cc: grant.likely@linaro.org, robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Gyungoh Yoo <jack.yoo@skyworksinc.com>
Subject: [PATCH v2.2 0/2] regulator: sky81452: Adding compatible attribute in DT document
Date: Mon,  1 Sep 2014 11:40:16 +0900
Message-Id: <1409539218-5571-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140813190423.GI17528@sirena.org.uk>
References: <20140813190423.GI17528@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding comptiable attribute in DT document.
Splitted the patches for each subsystem.
Fixed typo in DT document.

Gyungoh Yoo (2):
  regulator: sky81452: Adding compatible attribute in DT
  dt-bindings: Adding compatible attribute for SKY81452 regulator

 .../bindings/regulator/sky81452-regulator.txt      |  4 +++-
 drivers/regulator/sky81452-regulator.c             | 22 ++++++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

-- 
1.9.1

