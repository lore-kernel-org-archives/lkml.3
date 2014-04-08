Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaDHPW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:22:57 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:58245 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756875AbaDHPW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:22:56 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Linus Walleij <linus.walleij@linaro.org>, Joe Perches <joe@perches.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH 0/2] pinctrl: st: Driver fixing & clean-up
Date: Tue,  8 Apr 2014 17:21:47 +0200
Message-Id: <1396970509-28009-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-08_04:2014-04-08,2014-04-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is composed of two patches for ST pinctrl driver.

The first one makes use of const qualifier where applicable, as reported by
Joe Perches in the series adding support to STiH407 SoC.

The second one makes use of ARRAY_SIZE to pass the STiH415's delays table
size, instead of passing the raw value. This correction had already been done
for STiH416 table.

Maxime Coquelin (2):
  pinctrl: st: Use const qualifier when required
  pinctrl: st: Use ARRAY_SIZE for STiH415 data

 drivers/pinctrl/pinctrl-st.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

-- 
1.9.0

