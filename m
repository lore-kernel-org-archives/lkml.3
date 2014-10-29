Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbaJ2Nra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:47:30 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:46609 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039AbaJ2Nr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:47:26 -0400
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH v5 0/3] Add Phytec pbab01 audio support
Date: Wed, 29 Oct 2014 16:47:01 +0300
Message-ID: <1414590424-25585-1-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By mistake previous patchset versions was sent as in-reply-to to
previous patchset versions, so they may have been lost among other
mails.

One of pathces was already applied by Mark Brown, here is 3 patches
implementing audio support on Phytec phyFLEX-i.MX6 boards.

This patchset version only renames audio card name to
OnboardTLV320AIC3007 (on request from Phytec).

Patches are based on branch for-next of
git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git

