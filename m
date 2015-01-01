Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbbAAJZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 04:25:35 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:35636 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbAAJZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 04:25:13 -0500
X-Mailbox-Line: From e57c95c0e966055ddf2c65cddbec665fab7641c6 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1420102454.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 1 Jan 2015 09:54:14 +0100
Subject: [PATCH v6 0/3] ASoC: simple-card: Add multi-CODEC support
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds multi-CODEC support to the simple card.

v6: (Mark Brown)
	- don't stop unreferencing the codec nodes on null node
	- split the patch about simple-card.c
	- add example 3 in the DT binding
v5: accept only "sound-dai" as the dai link property (Arnd Bergmann)
v4: (Mark Brown)
	- document the new core function
	- calculation of the number of codecs moved to the core function
	- split the patch about simple-card.c
	- less code changes
	- remove the cast of pointers
	- less changes in the DT binding example 2
v3: rebase on broonie git 2014/11/03
v2: accept list of CODECs in 'sound-dais' (Benoit Cousson)

Happy New Year!

Jean-Francois Moine (3):
  ASoC: simple-card: prepare multi-CODECs
  ASoC: simple-card: Add multi-CODECs in DT
  ASoC: simple-card: Remove useless check

 .../devicetree/bindings/sound/simple-card.txt      | 19 ++++-
 sound/soc/generic/simple-card.c                    | 81 +++++++++++-----------
 2 files changed, 60 insertions(+), 40 deletions(-)

-- 
2.1.4

