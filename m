Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3DUNDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 09:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3DUNDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 09:03:52 -0400
Date: Sun, 21 Apr 2013 16:03:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: mtosatti@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/15] KVM: MMU: fast zap all shadow pages
Message-ID: <20130421130346.GE8997@redhat.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 02:32:38PM +0800, Xiao Guangrong wrote:
> This patchset is based on my previous two patchset:
> [PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
> (https://lkml.org/lkml/2013/4/1/2)
> 
> [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
> (https://lkml.org/lkml/2013/4/1/134)
> 
> Changlog:
> V3:
>   completely redesign the algorithm, please see below.
> 
This looks pretty complicated. Is it still needed in order to avoid soft
lockups after "avoid potential soft lockup and unneeded mmu reload" patch?

--
			Gleb.
