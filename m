Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaJ1LCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:02:10 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64422 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbaJ1LCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:02:04 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv2 0/6] net: fec: fix regression on i.MX28 introduced by rx_copybreak support
Date: Tue, 28 Oct 2014 12:01:38 +0100
Message-Id: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes wrt. v1:
- added some cleanup patches
- simplify handling of 'quirks' flags as suggested by Russell King.
- remove DIV_ROUND_UP() from byte swapping loop as suggested by
  Eric Dumazet

Subject: 
In-Reply-To: 

