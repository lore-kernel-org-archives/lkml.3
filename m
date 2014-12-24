Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaLXHMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:12:21 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:59686 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaLXHMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:12:19 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <gregkh@linuxfoundation.org>
CC: <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robh@kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 0/3] Early 8250 fixlets
Date: Wed, 24 Dec 2014 12:42:13 +0530
Message-ID: <1419405136-14520-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.182]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series addresses some of the issues seen on early 8250 uart when
working with ARC SDP platform.

Thx,
-Vineet

Vineet Gupta (3):
  serial: 8250_early: optimize early 8250 uart
  serial: 8250_early: prepare for dynamic BASE_BAUD
  ARC: runtime determine BASE_BAUD per machine

 arch/arc/include/asm/serial.h        | 24 ++++--------------------
 arch/arc/kernel/devtree.c            | 24 ++++++++++++++++++++++++
 drivers/tty/serial/8250/8250_early.c |  7 +++++--
 drivers/tty/serial/earlycon.c        | 13 +++++++++++--
 4 files changed, 44 insertions(+), 24 deletions(-)

-- 
1.8.3.2

