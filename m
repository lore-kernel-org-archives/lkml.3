Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab3DXKqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:46:20 -0400
Received: from 8bytes.org ([85.214.48.195]:55835 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758522Ab3DXKqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:46:19 -0400
Date: Wed, 24 Apr 2013 12:46:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Don Dutile <ddutile@redhat.com>
Cc: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
Message-ID: <20130424104616.GH17148@8bytes.org>
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130418160220.GA4153@8bytes.org>
 <51701B9F.10003@amd.com>
 <20130418162856.GA13891@8bytes.org>
 <51768B25.1060501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51768B25.1060501@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Apr 24 12:46:17 2013
X-DSPAM-Confidence: 0.9987
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5177b7f923672037037569
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 09:22:45AM -0400, Don Dutile wrote:
> Given other threads on this mail list (and I've seen crashes with same problem)
> where this type of logging during a flood of IOMMU errors will lock up the machine,
> is there something that can be done to break the do-while loop after n iterations
> have been exec'd, so the kernel can progress during a crash ?

In the case of an IOMMU error flood this loop will only run until the
event-log/ppr-log overflows. So it should not turn into an endless loop.


	Joerg


