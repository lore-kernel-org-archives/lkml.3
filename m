Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaKKQc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:32:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:54607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaKKQcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:32:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="486551109"
Message-ID: <54623A10.9030705@linux.intel.com>
Date: Wed, 12 Nov 2014 00:32:16 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 00/15] arm64: PCI/MSI: GICv3 ITS support (stacked domain
 edition)
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com> <546234FA.3060501@linux.intel.com> <546238FA.3040307@arm.com>
In-Reply-To: <546238FA.3040307@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/12 0:27, Marc Zyngier wrote:
> On 11/11/14 16:10, Jiang Liu wrote:
>> Hi Marc,
>> 	Sorry for the late notification. I have heavily reworked the
>> interfaces for MSI irqdomain support based on review comments.
>> Please refer to https://lkml.org/lkml/2014/11/9/88, please give your
>> comments on the new interfaces:)
> 
> Ah, I feel like I have more catch-up to do. Hopefully the changes are
> simple enough to implement. Rebase time...
The new interfaces are still RFC, so comments are warmly welcomed!
Regards!
Gerry
> 
> Thanks,
> 
> 	M.
> 
