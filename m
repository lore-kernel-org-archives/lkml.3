Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaJCNT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:19:28 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:59571 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCNTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:19:24 -0400
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH v4 0/4] Add Phytec pbab01 audio support
Date: Fri, 3 Oct 2014 16:18:52 +0300
Message-ID: <1412342336-25700-1-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1410854903-26419-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1410854903-26419-1-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New phyFLEX board audio patchset version.

Small changes made since last version:

- removed unnecessary 'regulator-always-on' in fixed regulators dts
  description;
- removed 'fsl,mode = "i2s-slave"' from ssi2 node in dts since it was
  already removed from fsl-ssi driver.

Based on branch for-next from
git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git
