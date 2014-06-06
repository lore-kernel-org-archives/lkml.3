Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaFFVo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:44:29 -0400
Received: from mx1.scotdoyle.com ([69.85.92.149]:54705 "EHLO mx1.scotdoyle.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbaFFVo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:44:28 -0400
Date: Fri, 6 Jun 2014 23:44:25 +0100 (BST)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
cc: Yao Jin <yao.jin@intel.com>, Aubrey Li <aubrey.li@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [4/4] i2c: designware-pci: Add Haswell PCI IDs
In-Reply-To: <1400164644-3222-5-git-send-email-mika.westerberg@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1406062340400.32753@scotdoyle.com>
References: <1400164644-3222-5-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch works on a Toshiba CB35 Chromebook, applied against 3.15-rc8.

On Thu, 15 May 2014, Mika Westerberg wrote:
> Intel Haswell has the same I2C host controller than Baytrail and it can
> also be enumerated as a PCI device. Add the PCI IDs to the driver list.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> ---
> drivers/i2c/busses/i2c-designware-pcidrv.c | 22 ++++++++++++++++++++++
> 1 file changed, 22 insertions(+)
