Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab3FQJBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:01:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34575 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3FQJBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:01:08 -0400
Message-ID: <51BED04E.6030007@arm.com>
Date: Mon, 17 Jun 2013 10:01:02 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steve Capper <steve.capper@linaro.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: linux-next: manual merge of the arm64-hugepages tree with the
 arm64 tree
References: <20130617174528.fc0381c10f8c5296b4efe776@canb.auug.org.au> <20130617084224.GB28225@linaro.org>
In-Reply-To: <20130617084224.GB28225@linaro.org>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 17 Jun 2013 09:01:02.0958 (UTC) FILETIME=[319688E0:01CE6B39]
X-MC-Unique: 113061710010512401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/13 09:42, Steve Capper wrote:
> On Mon, Jun 17, 2013 at 05:45:28PM +1000, Stephen Rothwell wrote:
>> Hi Steve,
> 
> Hi Stephen,
> 
>>
>> Today's linux-next merge of the arm64-hugepages tree got conflicts in
>> arch/arm64/include/asm/pgtable-hwdef.h and
>> arch/arm64/include/asm/pgtable.h between commit 363116073a26 ("arm64:
>> KVM: define HYP and Stage-2 translation page flags") from the arm64 tree
>> and commits 072b1b62a643 ("ARM64: mm: Make PAGE_NONE pages read only and
>> no-execute") and af07484863e0 ("ARM64: mm: THP support") from the
>> arm64-hugepages tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>>
> 
> Thanks, the fixup looks good to me.
> 
>> Note that the arm64 tree version of PMD_SECT_USER used a pteval_t where I
>> would have expected a pmdval_t like the arm64-hugepages tree version.
> 
> Yes I think it should be a pmdval_t too, I will follow this up.

Indeed, my bad. I'll fix this ASAP.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

