Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab3HAKKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:10:51 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51164 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab3HAKKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:10:50 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="40707583"
Message-ID: <51FA3428.9020403@citrix.com>
Date: Thu, 1 Aug 2013 11:10:48 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH 2/3] xen-blkfront: improve aproximation of
 required grants per request
References: <1375282844-4314-1-git-send-email-roger.pau@citrix.com> <1375282844-4314-3-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1375282844-4314-3-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/13 16:00, Roger Pau Monne wrote:
> Improve the calculation of required grants to process a request by
> using nr_phys_segments instead of always assuming a request is going
> to use all posible segments.
> 
> nr_phys_segments contains the number of scatter-gather DMA addr+len
> pairs, which is basically what we put at every granted page.
> for_each_sg iterates over the DMA addr+len pairs and uses a grant
> page for each of them.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
