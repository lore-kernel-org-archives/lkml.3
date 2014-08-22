Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaHVEna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:43:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:30796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaHVEn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:43:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="375597158"
Date: Fri, 22 Aug 2014 12:45:03 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 0/7] Dynamic Pause Loop Exiting window.
Message-ID: <20140822044503.GB4807@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
 <53F61EAC.2000004@redhat.com>
 <20140821165002.GG20453@potion.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140821165002.GG20453@potion.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Radim,
On Thu, Aug 21, 2014 at 06:50:03PM +0200, Radim Krčmář wrote:
>2014-08-21 18:30+0200, Paolo Bonzini:
>> Il 21/08/2014 18:08, Radim Krčmář ha scritto:
>> I'm not sure of the usefulness of patch 6, so I'm going to drop it.
>> I'll keep it in my local junkyard branch in case it's going to be useful
>> in some scenario I didn't think of.
>
>I've been using it to benchmark different values, because it is more

Is there any benchmark data for this patchset?

Regards,
Wanpeng Li 

>convenient than reloading the module after shutting down guests.
>(And easier to sell than writing to kernel memory.)
>
>I don't think the additional code is worth it though.
>
>> Patch 7 can be easily rebased, so no need to repost (and I might even
>> squash it into patch 3, what do you think?).
>
>Yeah, the core is already a huge patch, so it does look weird without
>squashing.  (No-one wants to rebase to that point anyway.)
>
>Thanks.
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
