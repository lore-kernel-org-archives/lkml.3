Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaIVWWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:22:15 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57277 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaIVWWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:22:13 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 0/3] media:st-rc: Misc fixes.
Date: Mon, 22 Sep 2014 23:21:41 +0100
Message-Id: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Thankyou for the "[media] enable COMPILE_TEST for media drivers" patch
which picked up few things in st-rc driver in linux-next testing.

Here is a few minor fixes to the driver, could you consider them for
the next merge window.

Thanks,
srini

Srinivas Kandagatla (3):
  media: st-rc: move to using reset_control_get_optional
  media: st-rc: move pm ops setup out of conditional compilation.
  media: st-rc: Remove .owner field for driver

 drivers/media/rc/st_rc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
1.9.1

