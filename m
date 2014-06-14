Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaFNN0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:26:44 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:41343 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbaFNN0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:26:41 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wireless: rtlwifi: rtl8188ee: reg.h:  Cleaning up if statement that always evaluates to false 
Date: Sat, 14 Jun 2014 15:27:37 +0200
Message-Id: <1402752458-13836-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a logical error in an if statement that always evaluates to false.

This has after same discussion resulted in that we add a macro to handle this.

This was partly found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  net: wireless: rtlwifi: rtl8188ee: reg.h:  Cleaning up if statement that always evaluates to false

 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h |    1 +
 1 file changed, 1 insertion(+)

-- 
1.7.10.4

