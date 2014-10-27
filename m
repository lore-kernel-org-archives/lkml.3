Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJ0NJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:09:19 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:31369 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaJ0NJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:09:16 -0400
X-IronPort-AV: E=Sophos;i="5.04,796,1406592000"; 
   d="scan'208";a="186460076"
Message-ID: <544E43E8.8000704@citrix.com>
Date: Mon, 27 Oct 2014 13:08:56 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH 03/16] x86/xen/MSI: Use MSI controller framework
 to configure MSI/MSI-X irq
References: <1414416142-31239-1-git-send-email-wangyijing@huawei.com> <1414416142-31239-4-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1414416142-31239-4-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/14 13:22, Yijing Wang wrote:
> Use MSI controller framework instead of arch MSI functions to configure
> MSI/MSI-X irq. So we can manage MSI/MSI-X irq in a unified framework.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
