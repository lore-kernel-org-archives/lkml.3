Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab3HNKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:25:57 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:50991 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3HNKZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:25:56 -0400
Date: Wed, 14 Aug 2013 12:27:15 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 0/1] ASoc: kirkwood: extend the kirkwood audio subsystem
 for DT usage
Message-ID: <20130814122715.45c2d9ad@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds DT support to the kirkwood/mvebu audio subsystem.

History
v5
	- change the DT name to "marvell,mvebu-audio"
v4
	- change the DT name to "mrvl,mvebu-audio"
	- remove previous patches 1..3 which have been applied by Russell King
v3
	- change the DT name from "kirkwood-i2s" to "mvebu-pcm-audio"
	- apply to linux-next
	- let NULL as the internal i2s clock for compatibility
	- change i2s external clock name to "extclk" instead of "external"
	- cancel previous patch 1/4. Russell's patch should be applied instead.
v2
	- fix compilation errors

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
