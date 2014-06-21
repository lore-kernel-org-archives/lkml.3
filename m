Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaFUU7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:59:42 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33638 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaFUU7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:59:39 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>, Peter Wu <lekensteyn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wireless: rtlwifi: rtl8192cu: hw.c:  Cleaning up if statement that always evaluates to false 
Date: Sat, 21 Jun 2014 23:00:36 +0200
Message-Id: <1403384437-9615-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a logical error in an if statement that always evaluates to false.

This has after same discussion resulted in that we add a macro to handle this.

This was partly found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  net: wireless: rtlwifi: rtl8192cu: hw.c:  Cleaning up if statement that always evaluates to false

 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

-- 
1.7.10.4

