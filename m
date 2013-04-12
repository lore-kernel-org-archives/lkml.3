Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3DLJob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:44:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:35471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab3DLJo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,462,1363158000"; 
   d="scan'208";a="321340925"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 0/1] serial: 8250_dw: fix for tty-next
Date: Fri, 12 Apr 2013 12:44:26 +0300
Message-Id: <1365759867-29657-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Heikki Krogerus (1):
  serial: 8250_dw: Fix the stub for dw8250_probe_acpi()

 drivers/tty/serial/8250/8250_dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.10.4

