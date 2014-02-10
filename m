Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaBJKyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:54:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32619 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaBJKyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:54:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7344"; a="13154263"
X-IronPort-AV: E=McAfee;i="5400,1158,7344"; a="615705743"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <wil6210@qca.qualcomm.com>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] wil6210: Fix switch operator "missing break?" warning
Date: Mon, 10 Feb 2014 12:54:13 +0200
Message-ID: <3132701.EBRqRlvTI9@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140207144639.GA10939@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com> <aedc9b7eb82232204a7d65b4c7d3302ba6ba3892.1389904167.git.agordeev@redhat.com> <20140207144639.GA10939@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 07, 2014 03:46:40 PM Alexander Gordeev wrote:
> This update fixes a warning introduced with commit bc977ba1
> ("wil6210: Use pci_enable_msi_range() instead of pci_enable_msi_block()")
> 
> drivers/net/wireless/ath/wil6210/pcie_bus.c:65 wil_if_pcie_enable()
> warn: missing break? reassigning 'use_msi'
> 

I can't reproduce this warning. What tools used to get it?
Neither gcc (I have 4.8.1) nor sparse report it.

Anyway, I am fine with both 'switch' and 'if'.

Thanks, Vladimir.


