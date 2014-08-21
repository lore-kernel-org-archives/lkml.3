Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaHUQvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaHUQvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:51:16 -0400
Date: Thu, 21 Aug 2014 17:58:34 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tomas Henzl <thenzl@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        James Smart <james.smart@emulex.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140821165833.GA5853@agordeev.usersys.redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
 <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
 <53F5D8DF.4060705@redhat.com>
 <53F5DEEF.4070406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F5DEEF.4070406@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 01:58:39PM +0200, Tomas Henzl wrote:
> my bad, this was already fixed in
> commit 029165acfa611a3a8838723f6978586ae35ff53d lpfc: Remove superfluous call to pci_disable_msix()
> 
> so patch looks good to me now

Many thanks for your reviews, Tomas!

> Reviewed-by: Tomas Henzl

Christoph, this patch was declined by James few times.
I think it needs his approval as well.

James?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
