Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaGJNdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:33:50 -0400
Received: from 8bytes.org ([85.214.48.195]:52146 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbaGJNds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:33:48 -0400
Date: Thu, 10 Jul 2014 15:33:46 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AMD IOMMU v2: Drop oprofile dependency
Message-ID: <20140710133346.GX1958@8bytes.org>
References: <1404989096-20104-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404989096-20104-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:33:46 2014
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be963a20864018114075
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 12:44:56PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> a40d4c67d7de ("iommu/amd: Implement mmu_notifier_release call-back")
> removed the oprofile task_exit notifier hack^Wusage but forgot to
> readjust the Kconfig dependency. Fix that.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/iommu/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied and fixed the subject to "iommu/amd: Drop oprofile dependency".

Thanks Boris :)


