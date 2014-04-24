Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaDXO5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869AbaDXO5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:57:35 -0400
Date: Thu, 24 Apr 2014 11:56:58 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@kernel.org, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 0/5] KVM: x86: flush tlb out of mmu-lock after write
 protection
Message-ID: <20140424145658.GA19004@amt.cnet>
References: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397725576-6617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 05:06:11PM +0800, Xiao Guangrong wrote:
> Since Marcelo has agreed the comments improving in the off-line mail, i
> consider this is his Ack. :) Please let me know If i misunderstood it.
> 
> This patchset is splited from my previous patchset:
> [PATCH v3 00/15] KVM: MMU: locklessly write-protect
> that can be found at:
> https://lkml.org/lkml/2013/10/23/265

Applied, thanks.

