Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3IXLF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 07:05:58 -0400
Received: from 8bytes.org ([85.214.48.195]:45242 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3IXLF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 07:05:57 -0400
Date: Tue, 24 Sep 2013 13:05:53 +0200
From: Joerg Roedel <joro@8bytes.org>
To: ZhenHua <zhen-hual@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Donald Dutile <ddutile@redhat.com>
Subject: Re: [PATCH 1/1] x86/iommu: correct ICS register offset
Message-ID: <20130924110551.GC4532@8bytes.org>
References: <1379053652-29206-1-git-send-email-zhen-hual@hp.com>
 <52381505.4010701@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52381505.4010701@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 24 13:05:56 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5241721420861280822175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 04:38:29PM +0800, ZhenHua wrote:
> Hi Guys,
>     Though  DMAR_ICS_REG is not used yet, I think this patch is
> necessary. So please take a look at it.

You are right, my Spec says the same. It doesn't matter much since the
register seems to be unused in the VT-d driver. I applied the patch to
iommu/fixes anyway.


	Joerg


