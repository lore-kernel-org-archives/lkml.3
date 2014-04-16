Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaDPUDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:03:00 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:61805 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaDPUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:02:58 -0400
Date: Wed, 16 Apr 2014 16:02:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/2] ahci: Use pci_enable_msi_exact() instead of
 pci_enable_msi_range()
Message-ID: <20140416200252.GH22569@htj.dyndns.org>
References: <cover.1396426390.git.agordeev@redhat.com>
 <aabd5aabbbbc79e5534a9922240c341c153d2156.1396426390.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabd5aabbbbc79e5534a9922240c341c153d2156.1396426390.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 10:19:57AM +0200, Alexander Gordeev wrote:
> The driver calls pci_enable_msi_range() function with the
> range of [nvec..nvec] which what pci_enable_msi_exact()
> function is for.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: linux-ide@vger.kernel.org

Please refresh this one after updating the first patch.

Thanks.

-- 
tejun
