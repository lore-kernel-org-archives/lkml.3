Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaKFNCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:02:15 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:35176 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKFNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:02:14 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Subject: NXP Semiconductors TFA9879 Amplifier Driver
Date: Thu,  6 Nov 2014 13:53:59 +0100
Message-Id: <1415278441-27866-1-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Sorry for not sending this from my axentia.se account, but I tend to
get high spam-scores from there when I use git send-email.

This is a new driver, and it's pretty minimalistic with support for
only a few basic controls. However, it is usable and I'd be happy
to see it included.

I don't know if it's presumptious to add myself as a maintainer, but
checkpatch complained...

Are the alsa control names wisely chosen?

Please review!

Cheers,
Peter
