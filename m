Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3DMP0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:26:07 -0400
Received: from 8bytes.org ([85.214.48.195]:42530 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab3DMP0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:26:06 -0400
Date: Sat, 13 Apr 2013 17:26:03 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Cooks <acooks@gmail.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] AMD IOMMU cleanups, fixes and IVRS bug workarounds
Message-ID: <20130413152602.GO6858@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
 <CAKocOOP5tMsDLS8Wotu0kMNjSVJpN+pPhE9zj+n9ZKS9EcVR+A@mail.gmail.com>
 <20130412080637.GN6858@8bytes.org>
 <CAJtEV7aLa2tKw-B0f0ZNHdP86yxpvUAofs9eVPYCeib6m67f8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJtEV7aLa2tKw-B0f0ZNHdP86yxpvUAofs9eVPYCeib6m67f8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Apr 13 17:26:03 2013
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5169790b23671392817008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 11:06:22PM +0800, Andrew Cooks wrote:
> On Fri, Apr 12, 2013 at 4:06 PM, Joerg Roedel <joro@8bytes.org> wrote:

> > Oh, that's sad. You were the only one having a machine wich actually has
> > unity-mapped ranges defined in the BIOS table. The code for those
> > mappings was basically untested before you ran it on that machine.
> >
> What is the machine in question? Maybe someone else has access to one,
> if it's not too exotic.

Shuah had access to a HP server machine (don't know which one) that
defined unity-map ranges in the BIOS table. Shuah certainly knows the
details about that machine.


	Joerg


