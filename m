Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3A0P3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 10:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab3A0P3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 10:29:17 -0500
Date: Sun, 27 Jan 2013 17:29:12 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, yoshikawa_takuya_b1@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] kvm: IOMMU read-only mapping support
Message-ID: <20130127152912.GC27509@redhat.com>
References: <20130124220027.11061.76400.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124220027.11061.76400.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 03:03:57PM -0700, Alex Williamson wrote:
> A couple patches to make KVM IOMMU support honor read-only mappings.
> This causes an un-map, re-map when the read-only flag changes and
> makes use of it when setting IOMMU attributes.  Thanks,
> 
> Alex
> 
Applied, thanks.

> ---
> 
> Alex Williamson (2):
>       kvm: Force IOMMU remapping on memory slot read-only flag changes
>       kvm: Obey read-only mappings in iommu
> 
> 
>  virt/kvm/iommu.c    |    4 +++-
>  virt/kvm/kvm_main.c |   28 ++++++++++++++++++++++++----
>  2 files changed, 27 insertions(+), 5 deletions(-)

--
			Gleb.
