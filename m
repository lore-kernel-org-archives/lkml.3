Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3IIPwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:52:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3IIPwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:52:05 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 0/2] regulator: da9210: support Device Tree initialisation
Date: Mon,  9 Sep 2013 17:51:58 +0200
Message-Id: <1378741920-11085-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:T3m0jIJW/rYJUoA65a9fev2/HQAvzA8FcMsO+/UFuy3
 0RzanDnnaxVCFxcnwPWhRhAUwdzIX679FoXlr6cJUPgwRbMlJL
 9iayeG+uC4sO2UABhRc2aXDN+M6mjMHJDdGg92Ylvsmblghg5H
 I3Z/JcXSR4OVQ7uiVCfT47jVtw3Yn24z9qfmj8aSi+1pX6DOxa
 CTfGAc8IRZ3OosruWl0ORoQncGqqvyiWsR7g0ordZcxV1pK0bh
 MJLSGG7InH5HT93aWhIZ3cdyDBdXzLtHXL/i6VLKKx5zGyDJyZ
 eHX5ktqG7wwweU0vXx6v9Or1EfaCTef0DJkH+EqjWgDa2cTbR9
 Kz98J11Q9VdqSx8pcGV7FV3nxCeveslIIKzJ+qb8Tl7NNwyaJ/
 9UYEcVw96dZ5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch just adds a vendor prefix for Dialog Semiconductor PLC, the
second one actually implements DT support in da9210.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Guennadi Liakhovetski (2):
  DT: add a vendor prefix for Dialog Semiconductor
  regulator: da9210: add Device Tree support

 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/regulator/da9210-regulator.c               |    9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
