Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaAGOlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:41:20 -0500
Received: from 8bytes.org ([85.214.48.195]:36242 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaAGOlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:41:13 -0500
Date: Tue, 7 Jan 2014 15:41:09 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/iommu: use bit structures for context_entry
Message-ID: <20140107144108.GF2742@8bytes.org>
References: <1387529101-29769-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387529101-29769-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan  7 15:41:11 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52cc120720865196916863
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 04:45:01PM +0800, Li, Zhen-Hua wrote:
> There is a structure named context_entry used by intel iommu, and there
> are some bit operations on it. Use bit structure may make these operations
> easy.
> Also the function context_set_address_root may cause problem because it uses
>  |= operation, not set the new value. And this patch can fix it.

What is the problem you are trying to fix here? Is it an actual bug?


	Joerg


