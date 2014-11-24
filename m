Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaKXKwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:52:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:37230 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaKXKwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:52:08 -0500
Date: Mon, 24 Nov 2014 11:51:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: linux-next: manual merge of the tip tree with the pci tree
In-Reply-To: <20141124161842.02251126@canb.auug.org.au>
Message-ID: <alpine.DEB.2.11.1411241147180.6439@nanos>
References: <20141124161842.02251126@canb.auug.org.au>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Stephen Rothwell wrote:
> Today's linux-next merge of the tip tree got a conflict in
> drivers/pci/host/pcie-rcar.c between commit 3c70637f7569 ("PCI: rcar:
> Make rcar_pci static") from the pci tree and commit 7c35c8cc32f3 ("PCI:
> rcar: Save MSI controller in pci_sys_data") from the tip tree.

Bjorn redid his pci/msi branch. The older version of this branch has
been in the tip/tree to base a larger set of MSI irq related changes
on it. I rebased on Bjorns latest so that conflict should be gone
tomorrow.

Thanks,

	tglx

	
