Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbaIWT77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:59:59 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:47052 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaIWT7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:59:54 -0400
X-ASG-Debug-ID: 1411502391-0759e761297407b0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 0/2] Fix a division by zero
Date: Tue, 23 Sep 2014 21:54:38 +0200
X-ASG-Orig-Subj: [PATCH 0/2] Fix a division by zero
Message-ID: <1411502080-19769-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411502391
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9797
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's a couple of patches that fix a divison by zero in omap-serial.c. One's a
cleanup, the other the actual fix.

Thanks,
Frans

Frans Klaver (2):
  tty: omap-serial: pull out calculation from baud_is_mode16
  tty: omap-serial: fix a division by zero

 drivers/tty/serial/omap-serial.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

-- 
2.1.0

