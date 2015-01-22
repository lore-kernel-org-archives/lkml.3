Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbbAVPuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:50:06 -0500
Received: from bubo.tul.cz ([147.230.16.1]:57755 "EHLO bubo.tul.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbbAVPuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:50:03 -0500
Message-ID: <54C11C1A.3020307@tul.cz>
Date: Thu, 22 Jan 2015 16:49:46 +0100
From: Petr Cvek <petr.cvek@tul.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131204 Thunderbird/17.0.11
MIME-Version: 1.0
To: michal.simek@xilinx.com, delicious.quinoa@gmail.com,
        gnomes@lxorguk.ukuu.org.uk, jgunthorpe@obsidianresearch.com,
        atull@opensource.altera.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
CC: linux-kernel@vger.kernel.org
Subject: FPGA Manager Framework
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I was looking for any existing Xilinx AXI HWICAP linux driver (it seems 
only OPB/XPS exists) and I found this discussion. Is there existing 
(even alpha version) backend for ICAP in Kintex-7 ? If this framework 
will be in future kernel, it is IMHO better to use this than trying to 
patch old XPS driver.

My use case is dynamic partial reconfiguration of Microblaze processors.

P.S. Please CC me to any future discussion.

Petr

