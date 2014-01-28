Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaA1Kpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:45:45 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:37929 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1Kpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:45:43 -0500
X-IronPort-AV: E=Sophos;i="4.95,735,1384300800"; 
   d="scan'208";a="95174994"
Message-ID: <52E78A55.3050905@citrix.com>
Date: Tue, 28 Jan 2014 10:45:41 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Julien Grall <julien.grall@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <ian.campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <patches@linaro.org>
Subject: Re: [PATCH] xen/gnttab: Use phys_addr_t to describe the grant frame
 base address
References: <1390871025-29079-1-git-send-email-julien.grall@linaro.org>
In-Reply-To: <1390871025-29079-1-git-send-email-julien.grall@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/14 01:03, Julien Grall wrote:
> On ARM, address size can be 32 bits or 64 bits (if CONFIG_ARCH_PHYS_ADDR_T_64BIT
> is enabled).
> We can't assume that the grant frame base address will always fits in an
> unsigned long. Use phys_addr_t instead of unsigned long as argument for
> gnttab_setup_auto_xlat_frames.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
