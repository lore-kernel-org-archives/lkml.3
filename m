Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbaAHMTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:19:08 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18251 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbaAHMTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:19:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7311"; a="6012167"
X-IronPort-AV: E=McAfee;i="5400,1158,7311"; a="572335851"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <wil6210@qca.qualcomm.com>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7/7] wil6210: Use new interfaces for MSI enablement
Date: Wed, 8 Jan 2014 14:19:01 +0200
Message-ID: <6233363.QgbOXU7oZU@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140108115400.GD20157@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com> <1649789.pNiBbZVqTd@lx-vladimir> <20140108115400.GD20157@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 08, 2014 12:54:01 PM Alexander Gordeev wrote:
> Vladimir,
> 
> This series is against pci/msi branch in Bjorn Helgaas's repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
> 
> Commit 302a252 "PCI/MSI: Add pci_enable_msi_range() and pci_enable_msix_range()"
> 

Thanks, see it. New code don't distinguish between negative and positive error
values, same as old code. I'll fix it.

Meanwhile, below my

Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
