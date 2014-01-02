Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaABUjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:39:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaABUjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:39:14 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH] KVM: NULL return of kvmppc_mmu_hpte_cache_next should be handled
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1385979718-26218-1-git-send-email-yizhouzhou@ict.ac.cn>
Date: Thu, 2 Jan 2014 21:39:07 +0100
Cc: "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <A0A3F92A-2A78-49E3-B7D4-0D0A1F48191A@suse.de>
References: <1385979718-26218-1-git-send-email-yizhouzhou@ict.ac.cn>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02.12.2013, at 11:21, Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:

> NULL return of kvmppc_mmu_hpte_cache_next should be handled
> 
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>

Thanks, applied to kvm-ppc-queue.


Alex

