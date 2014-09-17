Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaIQP0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:26:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54238 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755345AbaIQP0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:26:02 -0400
Date: Wed, 17 Sep 2014 17:25:58 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org,
        Gregory =?UTF-8?B?Q2zDqW1lbnQ=?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Nadav Haklai <nadavh@marvell.com>
Subject: Re: [PATCH v2 0/3] PCI/MSI: Remove arch_msi_check_device()
Message-ID: <20140917172558.5847e16f@free-electrons.com>
In-Reply-To: <cover.1410078503.git.agordeev@redhat.com>
References: <cover.1410078503.git.agordeev@redhat.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexander Gordeev,

On Sun,  7 Sep 2014 20:57:52 +0200, Alexander Gordeev wrote:

> Alexander Gordeev (3):
>   patch 1 - PCI/MSI/PPC: Remove arch_msi_check_device()
>   patch 2 - PCI/MSI/Armada-370-xp: Remove arch_msi_check_device()
>   patch 3 - PCI/MSI: Remove arch_msi_check_device()

For the entire series:

Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

I tested on the Armada XP GP platform, which is particularly affected
by PATCH 2/3, as it is using the irq-armada-370-xp irqchip driver. I
tested with an igb PCIe NIC that supports MSI and MSI-X, and I verified
that MSI-X is still rejected (since we don't support it on Armada XP,
at least for now), and that MSI is accepted and actually works.

Thanks for doing this, and sorry for the delay in getting the patches
tested!

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
