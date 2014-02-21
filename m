Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBUTau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:30:50 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:33466 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaBUTat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:30:49 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 0/2] net: macb: Fixing DMA usage
Date: Fri, 21 Feb 2014 11:30:23 -0800
Message-Id: <1393011025-18537-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when I enabled CONFIG_DMA_API_DEBUG recently, I started seeing warnings
caused by the macb's DMA usage.
I read trough Documentation/DMA-API_HOWTO.txt and tried solving these to
the best of my knowledge of the networking and DMA systems. But that
knowledge is not very deep. So, there might be fundamental flaws with
these patches, hence as RFC only.

	Thanks,
	Sören

Soren Brinkmann (2):
  net: macb: Check DMA mappings for error
  net: macb: DMA-unmap full rx-buffer

 drivers/net/ethernet/cadence/macb.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

-- 
1.9.0.1.g4196000

