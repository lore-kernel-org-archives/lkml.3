Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaFRSy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:54:56 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60452 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaFRSyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:54:54 -0400
Date: Wed, 18 Jun 2014 14:54:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] AHCI: Use pci_enable_msi_partial() to conserve on
 10/16 MSIs
Message-ID: <20140618185450.GD11042@htj.dyndns.org>
References: <cover.1402405331.git.agordeev@redhat.com>
 <dba9f0f8e9cccd7625d0f3fab94457482e1a2bd7.1402405331.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dba9f0f8e9cccd7625d0f3fab94457482e1a2bd7.1402405331.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 03:10:32PM +0200, Alexander Gordeev wrote:
> Make use of the new pci_enable_msi_partial() interface and
> conserve on othewise wasted interrupt resources for 10 out
> of 16 unused MSI vectors on Intel chipsets.
> 
> Cc: x86@kernel.org
> Cc: xen-devel@lists.xenproject.org
> Cc: iommu@lists.linux-foundation.org
> Cc: linux-ide@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
