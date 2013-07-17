Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3GQRKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:10:40 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43376 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab3GQRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:10:38 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 0/3] arm: zynq: SLCR clean up
Date: Wed, 17 Jul 2013 10:10:12 -0700
Message-Id: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are just a few patches cleaning up the driver - well at least I
find it cleaner this way.
3/3 though adds correct read-modify-write for some register accesses.
The current implementation doesn't seem to do any harm, but this looks
better, IMHO.

	Sören

Soren Brinkmann (3):
  arm: zynq: slcr: Remove redundant header #includes
  arm: zynq: slcr: Clean up #defines
  arm: zynq: slcr: Use read-modify-write for register writes

 arch/arm/mach-zynq/slcr.c | 45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

-- 
1.8.3.3

