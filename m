Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3JVDEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 23:04:38 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:60910 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab3JVDEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 23:04:37 -0400
Date: Mon, 21 Oct 2013 21:04:22 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Ashley Lai <adlai@linux.vnet.ibm.com>, Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, Sirrix AG <tpmdd@sirrix.com>
Subject: Re: Re: [tpmdd-devel] TPM patches for 3.12
Message-ID: <20131022030422.GA19793@obsidianresearch.com>
References: <20131006193120.GA26137@obsidianresearch.com>
 <20131017145724.GA6528@obsidianresearch.com>
 <1382260018.11008.5.camel@fishsauce>
 <20131020170017.GA32542@obsidianresearch.com>
 <trinity-77042b98-668c-487b-a742-63606ea159f2-1382399439150@3capp-gmx-bs07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-77042b98-668c-487b-a742-63606ea159f2-1382399439150@3capp-gmx-bs07>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 01:50:39AM +0200, Peter Huewe wrote:

> Jason, can you please review and test my changes - 
> I'd probably send the pull request out tomorrow then.
> (giving me also the chance to think again whether I should add myself to MAINTAINERS or not ;)

Looks Ok, there are no major diffs against what I had.

Do you need to add your sign off lines on these patches?
 tpm: Rename tpm.c to tpm-interface.c
 tpm: Merge the tpm-bios module with tpm.o

Thanks,
Jason
