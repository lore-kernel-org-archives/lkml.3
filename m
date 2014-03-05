Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaCEHxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:53:15 -0500
Received: from 8bytes.org ([85.214.48.195]:60233 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaCEHxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:53:14 -0500
Date: Wed, 5 Mar 2014 08:53:12 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: Re: [PATCH] IOMMU: iommu module do not check NULL return of
 kmem_cache_zalloc
Message-ID: <20140305075312.GF27471@8bytes.org>
References: <1393986677-22160-1-git-send-email-yizhouzhou@ict.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393986677-22160-1-git-send-email-yizhouzhou@ict.ac.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar  5 08:53:13 2014
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5316d7e920862024062002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 10:31:17AM +0800, Zhouyi Zhou wrote:
> Thanks Joerg for reviewing
> Checking the null pointer in iopte_free guarantees kmem_cache_free
> is happy all the time.

Can you send this as a new patch in a new thread please?

Thanks,

	Joerg


