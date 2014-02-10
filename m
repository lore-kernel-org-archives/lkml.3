Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaBJKbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:31:52 -0500
Received: from smtp.citrix.com ([66.165.176.89]:38950 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaBJKbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:31:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,817,1384300800"; 
   d="scan'208";a="101261950"
Message-ID: <52F8AA78.80805@citrix.com>
Date: Mon, 10 Feb 2014 10:31:20 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>, <josh@joshtriplett.org>
Subject: Re: [PATCH 1/4] drivers: xen: Mark function as static in platform-pci.c
References: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com>
In-Reply-To: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 10:59, Rashika Kheria wrote:
> Mark function as static in xen/platform-pci.c because it is not used
> outside this file.
> 
> This eliminates the following warning in xen/platform-pci.c:
> drivers/xen/platform-pci.c:48:15: warning: no previous prototype for ‘alloc_xen_mmio’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Reviewed-by: David Vrabel <david,vrabel@citrix.com>

David
