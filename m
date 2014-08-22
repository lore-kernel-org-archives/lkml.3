Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaHVNQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:16:03 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33954 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250AbaHVNQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:16:01 -0400
X-IronPort-AV: E=Sophos;i="5.04,380,1406592000"; 
   d="scan'208";a="164151870"
Message-ID: <53F7428E.90806@citrix.com>
Date: Fri, 22 Aug 2014 14:15:58 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Arianna Avanzini <avanzini.arianna@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC: <bob.liu@oracle.com>, <felipe.franciosi@citrix.com>, <axboe@fb.com>
Subject: Re: [PATCH RFC 4/4] xen, blkback: add support for multiple block
 rings
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com> <1408706404-6614-5-git-send-email-avanzini.arianna@gmail.com>
In-Reply-To: <1408706404-6614-5-git-send-email-avanzini.arianna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/14 12:20, Arianna Avanzini wrote:
> This commit adds to xen-blkback the support to retrieve the block
> layer API being used and the number of available hardware queues,
> in case the block layer is using the multi-queue API. This commit
> also lets the driver advertise the number of available hardware
> queues to the frontend via XenStore, therefore allowing for actual
> multiple I/O rings to be used.

Does it make sense for number of queues should be dependent on the
number of queues available in the underlying block device?  What
behaviour do we want when a domain is migrated to a host with different
storage?

Can you split this patch up as well?

David
