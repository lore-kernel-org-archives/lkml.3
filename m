Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaDBNPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:15:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43341 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaDBNPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:15:16 -0400
X-IronPort-AV: E=Sophos;i="4.97,780,1389744000"; 
   d="scan'208";a="116085106"
Message-ID: <1396444512.8667.340.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH net-next v2 2/2] xen-netback: Grant copy the
 header instead of map and memcpy
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <jonathan.davies@citrix.com>,
        <wei.liu2@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <paul.durrant@citrix.com>,
        <xen-devel@lists.xenproject.org>
Date: Wed, 2 Apr 2014 14:15:12 +0100
In-Reply-To: <533C0C9F.8030205@citrix.com>
References: <1396278539-27639-1-git-send-email-zoltan.kiss@citrix.com>
		<1396278539-27639-2-git-send-email-zoltan.kiss@citrix.com>
	 <1396352440.8667.117.camel@kazak.uk.xensource.com>
	 <533C0C9F.8030205@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 14:11 +0100, David Vrabel wrote:

> I'd be in favour of a patch that:
> 
> - renamed gnttab_map_refs() to gnttab_batch_map_pages()
> - refactored it to call gnttab_batch_map().
> - added documentation
> 
> But I don't see why this would be a prerequisite for this series.

No, I think I misunderstoopd the API (because it is confusingly
named...)
> 
> David


