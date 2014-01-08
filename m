Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaAHLaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:30:52 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3942 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbaAHLau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:30:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7311"; a="57495426"
X-IronPort-AV: E=McAfee;i="5400,1158,7311"; a="24979538"
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <wil6210@qca.qualcomm.com>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7/7] wil6210: Use new interfaces for MSI enablement
Date: Wed, 8 Jan 2014 13:30:45 +0200
Message-ID: <1649789.pNiBbZVqTd@lx-vladimir>
Organization: Qualcomm Atheros
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <a5774459cb8eebfc95156b8cd3b249d896e04400.1389103215.git.agordeev@redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com> <a5774459cb8eebfc95156b8cd3b249d896e04400.1389103215.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 07:05:42 PM Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/net/wireless/ath/wil6210/pcie_bus.c |   36 ++++++++++++++------------
>  1 files changed, 19 insertions(+), 17 deletions(-)
> 

Patch looks fine, but I can't validate it as I can't find patch introducing
pci_enable_msi_range(). Where this patch landed on?

I am working with:
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

I also checked
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
and, of course
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Thanks, Vladimir
