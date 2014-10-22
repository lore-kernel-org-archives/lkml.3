Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaJVJJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:09:24 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:44426 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaJVJJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:09:19 -0400
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH v4 0/3 RESEND] Add Phytec pbab01 audio support
Date: Wed, 22 Oct 2014 12:08:31 +0300
Message-ID: <1413968914-13689-1-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1412342336-25700-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1412342336-25700-1-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch fixing PLL D configuration (number 4 in previous patchset) was
already accepted by Mark Brown. No notes or comments on other patches
was made so resending them in case they were lost.

Based on branch for-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git
