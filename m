Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaKKC2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:28:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:34755 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaKKC2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:28:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="486381135"
Message-ID: <5461745F.2080703@linux.intel.com>
Date: Tue, 11 Nov 2014 10:28:47 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Feng Wu <feng.wu@intel.com>
CC: gleb@kernel.org, pbonzini@redhat.com,
        David Woodhouse <dwmw2@infradead.org>, joro@8bytes.org,
        mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: several messages
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com> <1415600812-27773-14-git-send-email-feng.wu@intel.com> <alpine.DEB.2.11.1411101913340.3935@nanos>
In-Reply-To: <alpine.DEB.2.11.1411101913340.3935@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/11 2:15, Thomas Gleixner wrote:
> On Mon, 10 Nov 2014, Feng Wu wrote:
> 
>> VT-d Posted-Interrupts is an enhancement to CPU side Posted-Interrupt.
>> With VT-d Posted-Interrupts enabled, external interrupts from
>> direct-assigned devices can be delivered to guests without VMM
>> intervention when guest is running in non-root mode.
> 
> Can you please talk to Jiang and synchronize your work with his
> refactoring of the x86 interrupt handling subsystem.
> 
> I want this stuff cleaned up first before we add new stuff to it.
Hi Thomas,
	Just talked with Feng, we will focused on refactor first and
then add posted interrupt support.
Regards!
Gerry

> 
> Thanks,
> 
> 	tglx
> 
