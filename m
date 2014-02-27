Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaB0MnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:43:07 -0500
Received: from smtp.citrix.com ([66.165.176.89]:49881 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaB0MnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:43:04 -0500
X-IronPort-AV: E=Sophos;i="4.97,554,1389744000"; 
   d="scan'208";a="106251641"
Message-ID: <530F32C6.5060901@citrix.com>
Date: Thu, 27 Feb 2014 12:42:46 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: add support for MSI message groups
References: <1393431884-1120-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1393431884-1120-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/14 16:24, Roger Pau Monne wrote:
> Add support for MSI message groups for Xen Dom0 using the
> MAP_PIRQ_TYPE_MULTI_MSI pirq map type.
> 
> In order to keep track of which pirq is the first one in the group all
> pirqs in the MSI group except for the first one have the newly
> introduced PIRQ_MSI_GROUP flag set. This prevents calling
> PHYSDEVOP_unmap_pirq on them, since the unmap must be done with the
> first pirq in the group.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
