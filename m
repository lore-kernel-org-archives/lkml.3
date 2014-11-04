Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaKDNGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:06:23 -0500
Received: from s250.sam-solutions.net ([217.21.49.219]:53012 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaKDNGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:06:19 -0500
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <shawn.guo@linaro.org>, <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH v6 0/3] Add Phytec pbab01 audio support
Date: Tue, 4 Nov 2014 16:05:46 +0300
Message-ID: <1415106349-18846-1-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version of patchset contains following style changes since v5:
- nodes sorted in alphabetical order;
- pinctrl entries sorted alphabetically;
- new line inserted between nodes.

