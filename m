Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaG2PCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:02:44 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:33100 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaG2PCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:02:41 -0400
X-ASG-Debug-ID: 1406646158-0759e7416beb1660002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: <linux-serial@vger.kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/3] omap-serial high-speed fixes/improvements
Date: Tue, 29 Jul 2014 17:02:29 +0200
X-ASG-Orig-Subj: [RFC PATCH 0/3] omap-serial high-speed fixes/improvements
Message-ID: <1406646152-24698-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1406646158
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.7924
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apologies, something went wrong. Here's a resend.

Here's a couple of patches that should improve the behavior of the omap serial
driver at high data rates and baud rates.

I was actually surprised to see that proper dma support isn't there yet, but
there you go. Anyone got news on that, by the way?

Thanks for reviewing this,
Frans


Frans Klaver (3):
  tty: omap-serial: prevent division by zero
  tty: omap-serial: use threaded interrupt handler
  tty: omap-serial: support setting of hardware flow control in dts

 .../devicetree/bindings/serial/omap_serial.txt     |  1 +
 drivers/tty/serial/omap-serial.c                   | 52 ++++++++++++++++------
 2 files changed, 40 insertions(+), 13 deletions(-)

-- 
1.9.3

