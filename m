Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab3GaGQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:16:51 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:38717 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab3GaGQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:16:38 -0400
Date: Wed, 31 Jul 2013 08:17:11 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 0/4] ASoc: kirkwood: extend the kirkwood audio subsystem
 for DT usage
Message-ID: <20130731081711.417af22f@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds DT support to the kirkwood audio subsystem.

It cancels the previous patch requests:
- ARM: kirkwood: enable S/PDIF
- ARM: kirkwood: extend the kirkwood i2s driver for DT usage
- ARM: kirkwood: extend the kirkwood pcm/dma driver for DT usage

It also contains the merge of kirkwood-i2c and kirkwood-dma into one
module, with the removal of the kirkwood-pcm-audio device.
This involves changes in the openrd and t5325 drivers, and also in the
common Kirkwood machine initialization. These last changes have not
been tested.

History
v3
	- change the DT name from "kirkwood-i2s" to "mvebu-pcm-audio"
	- apply to linux-next
	- let NULL as the internal i2s clock for compatibility
	- change i2s external clock name to "extclk" instead of "external"
	- cancel previous patch 1/4. Russell's patch
		http://mailman.alsa-project.org/pipermail/alsa-devel/2013-July/064508.html
	  should be applied instead.
v2
	- fix compilation errors

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
