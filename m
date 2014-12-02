Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbaLBFzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:55:17 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:34335 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932854AbaLBFzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:55:13 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <timur@tabi.org>, <festevam@gmail.com>, <lars@metafoo.de>, <arnd@arndb.de>,
        <broonie@kernel.org>, <mpa@pengutronix.de>
CC: <alsa-devel@alsa-project.org>, <Li.Xiubo@freescale.com>,
        <linux-kernel@vger.kernel.org>, <lgirdwood@gmail.com>,
        <nicoleotsuka@gmail.com>, <tiwai@suse.de>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH v2 0/2] fsl_ssi misc fix
Date: Tue, 2 Dec 2014 14:55:05 +0900
Message-ID: <1417499707-3125-1-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes in v2:
	- fix error path in probe
	- replace irq_of_parse_and_map with platform_get_irq

Changes in v1:
	- free IRQ before irq_dispose_mapping

Jiada Wang (2):
  ASoC: fsl_ssi: fix error path in probe
  ASoC: fsl_ssi: use platform_get_irq instead of irq_of_parse_and_map

 sound/soc/fsl/fsl_ssi.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

-- 
1.9.3

