Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3IENLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:11:55 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:33357 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3IENLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:11:52 -0400
Date: Thu, 5 Sep 2013 09:11:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 5/6] AHCI: Check MRSM bit when multiple MSIs enabled
Message-ID: <20130905131149.GC26314@htj.dyndns.org>
References: <cover.1378383792.git.agordeev@redhat.com>
 <4bc31d6ccf3f84399b977fe8ed4fe77aadfa1c79.1378383792.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bc31d6ccf3f84399b977fe8ed4fe77aadfa1c79.1378383792.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 02:54:17PM +0200, Alexander Gordeev wrote:
> Do not trust the hardware and always check if MSI
> Revert to Single Message mode was enforced. Fall
> back to the single MSI mode in case it did. Not
> doing so might screw up the interrupt handling.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

 Acked-by: Tejun Heo <tj@kernel.org>

The patch should probably be re-sequenced to the head of the series
and cc stable@vger.kernel.org.  Not checking MRSM is scary.

Thanks.

-- 
tejun
