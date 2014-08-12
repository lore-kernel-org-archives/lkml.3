Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaHLF3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:29:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaHLF3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:29:01 -0400
Date: Tue, 12 Aug 2014 10:57:59 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>, jgarzik@bitpay.com, duwe@lst.de,
        Amos Kong <akong@redhat.com>, ricardo.neri-calderon@linux.intel.com,
        tytso@mit.edu, herbert@gondor.apana.org.au
Subject: Re: [PATCH 1/1] virtio: rng: add derating factor for use by hwrng
 core
Message-ID: <20140812052759.GI4184@grmbl.mre>
References: <6f2df652355d6e78da846d06e32489b7d9cdfcc2.1407782982.git.amit.shah@redhat.com>
 <53E93F77.9030305@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E93F77.9030305@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 11 Aug 2014 [15:11:03], H. Peter Anvin wrote:
> On 08/11/2014 11:49 AM, Amit Shah wrote:
> > The khwrngd thread is started when a hwrng device of sufficient
> > quality is registered.  The virtio-rng device is backed by the
> > hypervisor, and we trust the hypervisor to provide real entropy.  A
> > malicious hypervisor is a scenario that's ruled out, so we are certain
> > the quality of randomness we receive is perfectly trustworthy.  Hence,
> > we use 100% for the factor, indicating maximum confidence in the source.
> > 
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> 
> It isn't "ruled out", it is just irrelevant: if the hypervisor is
> malicious, the quality of your random number source is the least of your
> problems.

Yea; I meant ruled out in that sense.  Should the commit msg be more
verbose?

		Amit
