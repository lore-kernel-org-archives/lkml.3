Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3HONb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:31:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42797 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756006Ab3HONb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:31:56 -0400
Date: Thu, 15 Aug 2013 15:31:48 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: linux-next: manual merge of the mvebu tree with the pci tree
Message-ID: <20130815153148.579ad2e5@skate>
In-Reply-To: <20130814161840.dcee2b1354579cce7ff81730@canb.auug.org.au>
References: <20130814161840.dcee2b1354579cce7ff81730@canb.auug.org.au>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Stephen Rothwell,

On Wed, 14 Aug 2013 16:18:40 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the mvebu tree got a conflict in
> drivers/pci/host/Kconfig between commit 5477a33b51b7 ("PCI: mvebu: Make
> Marvell PCIe driver depend on OF") from the pci tree and commit
> 31d896ade95d ("PCI: mvebu: add support for Marvell Dove SoCs") from the
> mvebu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Your fix seems correct to me.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
