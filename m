Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab3HNQP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:15:29 -0400
Received: from 8bytes.org ([85.214.48.195]:50945 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab3HNQP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:15:28 -0400
Date: Wed, 14 Aug 2013 18:15:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: Re: [PATCH 1/3] powerpc: Add iommu domain pointer to device archdata
Message-ID: <20130814161522.GP28811@8bytes.org>
References: <1373863857-27239-1-git-send-email-Varun.Sethi@freescale.com>
 <20130814094802.GC4491@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D0A42CDB5@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D0A42CDB5@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 18:15:25 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520bad1d20865595313033
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:56:11AM +0000, Sethi Varun-B16395 wrote:
> Please find the .config file attached with this mail.

Fantastic, thanks. The build works fine, I'll include the driver into my
next-branch. I also have two minor clean-up patches on-top, just if you
where wondering.


	Joerg


