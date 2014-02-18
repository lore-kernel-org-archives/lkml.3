Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaBRU4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:56:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35801 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaBRU4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:56:38 -0500
Date: Tue, 18 Feb 2014 15:56:32 -0500 (EST)
Message-Id: <20140218.155632.1364973664624371603.davem@davemloft.net>
To: amirv@mellanox.com
Cc: agordeev@redhat.com, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: ixgbevf: Use pci_enable_msix_range() instead of
 pci_enable_msix()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140218120136.GA8770@mtl-eit-vdi-22.mtl.labs.mlnx>
References: <cover.1392717502.git.agordeev@redhat.com>
	<9ee830cfd4b417f230f77dd37256ca8e4396ecbe.1392717503.git.agordeev@redhat.com>
	<20140218120136.GA8770@mtl-eit-vdi-22.mtl.labs.mlnx>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2014 12:56:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Vadai <amirv@mellanox.com>
Date: Tue, 18 Feb 2014 14:01:38 +0200

> On 18/02/14 11:11 +0100, Alexander Gordeev wrote:
>> As result of deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range() and pci_enable_msix_range()
>> interfaces.
>> 
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
>> Cc: Bruce Allan <bruce.w.allan@intel.com>
>> Cc: e1000-devel@lists.sourceforge.net
>> Cc: netdev@vger.kernel.org
>> Cc: linux-pci@vger.kernel.org
>> ---
> 
> Acked-By: Amir Vadai <amirv@mellanox.com>

Since you obviously didn't intend to ACK this, I removed this ACK when
I committed the series.
