Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaHKSv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:51:28 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:33658 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbaHKSvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:51:25 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: ipw2x00: ipw2200.c:  Cleaning up missing null-terminate in conjunction with strncpy 
Date: Mon, 11 Aug 2014 20:52:55 +0200
Message-Id: <1407783176-31297-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason that can not simply use the variable ssid directly
in IPW_DEBUG_MERGE call instead of copying it to the escaped variable?

Rickard Strandqvist (1):
  net: wireless: ipw2x00: ipw2200.c:  Cleaning up missing null-terminate in conjunction with
    strncpy

 drivers/net/wireless/ipw2x00/ipw2200.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.10.4

