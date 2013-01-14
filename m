Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3ANQtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:49:52 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57496 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab3ANQtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:49:50 -0500
Date: Mon, 14 Jan 2013 08:49:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel J Blueman <daniel@quora.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v7 2/4] PCI: shpchp: Make shpchp_wq non-ordered
Message-ID: <20130114164942.GA27942@mtj.dyndns.org>
References: <20130113232606.7225.94802.stgit@bhelgaas.mtv.corp.google.com>
 <20130113232743.7225.11180.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130113232743.7225.11180.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 13, 2013 at 04:27:43PM -0700, Bjorn Helgaas wrote:
> e24dcbef93 ("shpchp: update workqueue usage") was described as adding
> non-ordered shpchp_wq, but it actually made it an *ordered* workqueue.
> 
> This patch changes shpchp_wq to be non-ordered, as described in the
> e24dcbef93 commit log and as was done for pciehp by a827ea307b ("pciehp:
> update workqueue usage").
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Tejun Heo <tj@kernel.org>

Yeap, my mistake.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
