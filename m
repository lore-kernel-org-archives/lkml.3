Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaKKQ1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:27:49 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52758 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaKKQ1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:27:48 -0500
Message-ID: <546238FA.3040307@arm.com>
Date: Tue, 11 Nov 2014 16:27:38 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
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
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com> <546234FA.3060501@linux.intel.com>
In-Reply-To: <546234FA.3060501@linux.intel.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 11 Nov 2014 16:27:39.0812 (UTC) FILETIME=[6941F640:01CFFDCC]
X-MC-Unique: 114111116274305501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 16:10, Jiang Liu wrote:
> Hi Marc,
> 	Sorry for the late notification. I have heavily reworked the
> interfaces for MSI irqdomain support based on review comments.
> Please refer to https://lkml.org/lkml/2014/11/9/88, please give your
> comments on the new interfaces:)

Ah, I feel like I have more catch-up to do. Hopefully the changes are
simple enough to implement. Rebase time...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

