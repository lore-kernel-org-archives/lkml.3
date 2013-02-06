Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3BFK0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:26:13 -0500
Received: from 8bytes.org ([85.214.48.195]:37189 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab3BFK0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:26:10 -0500
Date: Wed, 6 Feb 2013 11:26:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Stuart Yoder <b08248@gmail.com>
Cc: Sethi Varun-B16395 <B16395@freescale.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] iommu: Add domain window handling functions
Message-ID: <20130206102607.GB2634@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
 <1359983924-28952-5-git-send-email-joro@8bytes.org>
 <CALRxmdCiSZgoqd8tp90kPCdA=s7SWZCTwKsFnWu7S5=U7+eRLQ@mail.gmail.com>
 <20130204185650.GP25591@8bytes.org>
 <CALRxmdD9Ock04AoUtF9FT_uY5C5Eb7cSPmtCM6WK=StNB_iYkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALRxmdD9Ock04AoUtF9FT_uY5C5Eb7cSPmtCM6WK=StNB_iYkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb  6 11:26:09 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51122fc122972026860519
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 05:31:51PM -0600, Stuart Yoder wrote:
> On Mon, Feb 4, 2013 at 12:56 PM, Joerg Roedel <joro@8bytes.org> wrote:
> > Okay. So if your architecture supports sizes over 2^32 then size_t
> > probably is already 64bits, right?
> 
> No, on a 32-bit platform size_t would generally be 32-bits.  But the PAMU
> is independent of that.   I think we should just make it a u64.

Okay, you can find the patches in the 'core' branch of the iommu-tree.
They are also included in my next branch. You can use them now to base
the PAMU patches on it.


	Joerg


