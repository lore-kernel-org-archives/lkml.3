Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692Ab3GQRep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:34:45 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:33510 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab3GQReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:34:44 -0400
Date: Wed, 17 Jul 2013 19:34:42 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes)
 causes hang
Message-ID: <20130717173442.GA359@x4>
References: <20130717163215.GA359@x4>
 <20130717164232.GI13732@redhat.com>
 <20130717165743.GA357@x4>
 <A242AFC1-86E6-4716-8DF7-6FD169DB6EC8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A242AFC1-86E6-4716-8DF7-6FD169DB6EC8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.07.18 at 01:25 +0800, Xiao Guangrong wrote:
> Hi Markus,
> 
> Thanks for your report! I am downloading the ubuntu iso and will try to reproducible it.

Please note that the exact guest doesn't matter. I first noticed the
hang when I tried to install Fedora 19 today.

> Could you please enable these tracepoints:
> kvmmmu/check_mmio_spte
> kvmmmu/handle_mmio_page_fault
> kvmmmu/kvm_mmu_invalidate_zap_all_pages
> kvmmmu/mark_mmio_spte
> kvm/kvm_mmio
> kvm/vcpu_match_mmio
> 
> and post the output?

I will run this later.

> Just check, your host is 64-bit or 32 bit? 

Both guest and host are 64-bit.

-- 
Markus
