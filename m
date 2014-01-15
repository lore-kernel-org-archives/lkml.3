Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaAOPwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:52:30 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:35683 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaAOPw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:52:29 -0500
Date: Wed, 15 Jan 2014 16:51:28 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 0/8] ASoC: simple-card: simplify code
Message-ID: <20140115165128.479994c3@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set simplifies the code and make easier a possible multi-DAI
links extension.
--
v2:
	- split the changes into 8 patches (Mark Brown request)
	- remove the dynamic DAI link array allocation
	- fix lack of init function when DT use

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
