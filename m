Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbaGXMED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:04:03 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:58101 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717AbaGXMEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:04:00 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH 0/2] serial: st-asc: Couple of fixes
Date: Thu, 24 Jul 2014 14:02:54 +0200
Message-Id: <1406203376-18203-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-24_03:2014-07-24,2014-07-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains two fixes for ST's ASC driver.

The first issue addressed is a Kernel BUG when using the console on a different
ASC instance than the one being probed.

The second one is an overflow during buad rate calculation when requested rate
is higher than about 262Kbauds.

Maxime Coquelin (2):
  serial: st-asc: Don't call BUG in asc_console_setup()
  serial: st-asc: Fix overflow in baudrate calculation

 drivers/tty/serial/st-asc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
1.9.1

