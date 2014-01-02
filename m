Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbaABKqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:46:43 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45296 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750748AbaABKql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:46:41 -0500
Date: Thu, 2 Jan 2014 11:46:38 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jason Cooper <jason@lakedaemon.net>,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: mvebu: Remove redundant code
Message-ID: <20140102114638.47457689@skate>
In-Reply-To: <1388659296-21569-1-git-send-email-gregory.clement@free-electrons.com>
References: <1388659296-21569-1-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Thu,  2 Jan 2014 11:41:36 +0100, Gregory CLEMENT wrote:
> In the commit b42285f66f871a989, Sebastian moved clock enable before
> register access, but during the merge of the commit
> 9f352f0e6c0fa2dc608812df "PCI: mvebu: Dynamically detect if the PEX
> link is up to enable hot plug", the moved part was added back.
> 
> This patch fixes this by removing the redundant code.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/pci/host/pci-mvebu.c | 8 --------
>  1 file changed, 8 deletions(-)

This has already been fixed by
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/pci/host/pci-mvebu.c?id=84f47190d6be1cb99cd4a680e1018080d93800a8.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
