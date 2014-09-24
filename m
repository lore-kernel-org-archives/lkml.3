Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaIXHzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:55:35 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:42799 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaIXHzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:55:32 -0400
X-ASG-Debug-ID: 1411545329-0759e7612989fa30002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Frans Klaver <frans.klaver@xsens.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/2] 
Date: Wed, 24 Sep 2014 09:55:20 +0200
X-ASG-Orig-Subj: [PATCH v2 0/2] 
Message-ID: <1411545322-22940-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140923215831.GB651@kroah.com>
References: <20140923215831.GB651@kroah.com> <1411502080-19769-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411545330
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9817
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 11:58 PM, Greg Kroah-Hartman wrote:
> So both would be needed to be backported to stable kernels?  Why not
> just do the fix first, then the cleanup afterward, to make backporting
> easier?

Sure thing. I read something about cleaning up first, then actually changing
stuff, but it doesn't really make sense to move bugs around before fixing them,
unless fixing them requires moving them around.

Anyway, here's the respin.

v1..v2:
  - swapped fix and cleanup to ease backporting

Frans Klaver (2):
  tty: omap-serial: fix division by zero
  tty: omap-serial: pull out calculation from baud_is_mode16

 drivers/tty/serial/omap-serial.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

-- 
2.1.0

