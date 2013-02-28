Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3B1Pqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:46:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:59339 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab3B1Pqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:46:49 -0500
Subject: Re: [PATCH 3/6] powerpc/fsl_pci: Added defines for the FSL PCI controller BRR1 register.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20130227113336.GI26252@8bytes.org>
Date: Thu, 28 Feb 2013 09:46:51 -0600
Cc: Varun Sethi <Varun.Sethi@freescale.com>, iommu@lists.linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, stuart.yoder@freescale.com
Content-Transfer-Encoding: 8BIT
Message-Id: <414263AA-3E4B-4748-AD06-94F869261841@kernel.crashing.org>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com> <1361191939-21260-4-git-send-email-Varun.Sethi@freescale.com> <20130227113336.GI26252@8bytes.org>
To: Joerg Roedel <joro@8bytes.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 27, 2013, at 5:33 AM, Joerg Roedel wrote:

> On Mon, Feb 18, 2013 at 06:22:16PM +0530, Varun Sethi wrote:
>> Macros for checking FSL PCI controller version.
>> 
>> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
>> ---
>> arch/powerpc/include/asm/pci-bridge.h |    4 ++++
>> 1 files changed, 4 insertions(+), 0 deletions(-)
>> 
>> diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
>> index 025a130..c12ed78 100644
>> --- a/arch/powerpc/include/asm/pci-bridge.h
>> +++ b/arch/powerpc/include/asm/pci-bridge.h
>> @@ -14,6 +14,10 @@
>> 
>> struct device_node;
>> 
>> +/* FSL PCI controller BRR1 register */
>> +#define PCI_FSL_BRR1      0xbf8
>> +#define PCI_FSL_BRR1_VER 0xffff
>> +
> 
> 
> Please merge this patch with the one where you actually make use of
> these defines for the first time.
> 
> 
> 	Joerg

This also seems an odd place for these defines.

- k