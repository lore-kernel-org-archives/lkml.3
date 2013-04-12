Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3DLIGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:06:43 -0400
Received: from 8bytes.org ([85.214.48.195]:41076 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3DLIGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:06:39 -0400
Date: Fri, 12 Apr 2013 10:06:37 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] AMD IOMMU cleanups, fixes and IVRS bug workarounds
Message-ID: <20130412080637.GN6858@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
 <CAKocOOP5tMsDLS8Wotu0kMNjSVJpN+pPhE9zj+n9ZKS9EcVR+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOP5tMsDLS8Wotu0kMNjSVJpN+pPhE9zj+n9ZKS9EcVR+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Apr 12 10:06:38 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5167c08e23673402212137
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

On Wed, Apr 10, 2013 at 10:06:02AM -0600, Shuah Khan wrote:
> On Tue, Apr 9, 2013 at 2:12 PM, Joerg Roedel <joro@8bytes.org> wrote:
> >  Documentation/kernel-parameters.txt |   14 ++++
> >  drivers/iommu/amd_iommu.c           |   79 +++++++-----------
> >  drivers/iommu/amd_iommu_init.c      |  151 +++++++++++++++++++++++++++++++----
> >  drivers/iommu/amd_iommu_types.h     |    1 +
> >  4 files changed, 182 insertions(+), 63 deletions(-)

> Reviewed all the patches in this set. No longer have access to test machine. :(

Oh, that's sad. You were the only one having a machine wich actually has
unity-mapped ranges defined in the BIOS table. The code for those
mappings was basically untested before you ran it on that machine.
 
> Reviewed-by: Shuah Khan <shuahkhan@gmail.com>

Thanks.


	Joerg


