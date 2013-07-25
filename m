Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3GYJMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:12:30 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:46131 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3GYJM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:12:26 -0400
Date: Thu, 25 Jul 2013 11:12:32 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 0/4] ASoc: kirkwood: extend the kirkwood audio subsystem for
 DT usage
Message-ID: <20130725111232.08736072@armhf>
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
module, and, the removal of the kirkwood-pcm-audio device.
This involves changes in the openrd and t5325 drivers, as in the common
Kirkwood machine initialization. These last changes have not been tested.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
