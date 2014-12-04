Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaLDPqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:46:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:60778 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaLDPqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:46:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,516,1413244800"; 
   d="scan'208";a="200139589"
Message-ID: <548081E2.3080703@citrix.com>
Date: Thu, 4 Dec 2014 15:46:42 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v5] Fixes for PCI backend for 3.19.
References: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote:
> 
> These patches fix some issues with PCI back and also add proper
> bus/slot reset.

Applied 1-8 to devel/for-linus-3.19.  I did not apply #9.

Thanks.

David
