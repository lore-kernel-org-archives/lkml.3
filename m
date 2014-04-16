Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161144AbaDPNhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:37:46 -0400
Received: from 8bytes.org ([85.214.48.195]:33011 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbaDPNho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:37:44 -0400
Date: Wed, 16 Apr 2014 15:37:40 +0200
From: "joro@8bytes.org" <joro@8bytes.org>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Jiang Liu <jiang.liu@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
Subject: Re: hpsa driver bug crack kernel down!
Message-ID: <20140416133739.GB3577@8bytes.org>
References: <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
 <20140410071535.GX13491@8bytes.org>
 <1397119587.19944.14.camel@shinybook.infradead.org>
 <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
 <1397207932.19944.58.camel@shinybook.infradead.org>
 <1397490358.31076.6.camel@buesod1.americas.hpqcorp.net>
 <534C0AA9.5080909@linux.intel.com>
 <1397493858.31076.8.camel@buesod1.americas.hpqcorp.net>
 <1397494069.31076.9.camel@buesod1.americas.hpqcorp.net>
 <1397495030.19944.198.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397495030.19944.198.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Apr 16 15:37:43 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 534e87a720865533113978
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey David,

On Mon, Apr 14, 2014 at 05:03:51PM +0000, Woodhouse, David wrote:
> Jiang, if you can then let me have a copy with a signed-off-by I'll
> shepherd it upstream along with your other patch which is already in my
> iommu-2.6.git tree.

What is the state of these fixes? I plan to send out a pull-request
before easter and hoped to include these fixes as well.

Thanks,

	Joerg


