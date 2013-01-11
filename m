Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3AKTzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:55:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab3AKTza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:55:30 -0500
Date: Fri, 11 Jan 2013 17:09:56 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/5] KVM: x86: clear write_fault_to_shadow_pgtable
 explicitly
Message-ID: <20130111190956.GB17216@amt.cnet>
References: <50EBBE54.1040007@linux.vnet.ibm.com>
 <50EBBEEC.2060100@linux.vnet.ibm.com>
 <20130110173036.GB24703@amt.cnet>
 <50EF056B.4040803@linux.vnet.ibm.com>
 <20130111131511.GA18558@amt.cnet>
 <50F01DEA.6000005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F01DEA.6000005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 10:12:58PM +0800, Xiao Guangrong wrote:
> On 01/11/2013 09:15 PM, Marcelo Tosatti wrote:
> 
> > 
> > This is cryptic. Its not obvious at all for someone modifying the code, 
> > for example.
> > 
> > Can you please clear it explicitly? 
> 
> Sure, this is the patch to apply your idea, is it good to you? :)
> 
> ============================================
> Subject: [PATCH 6/6] KVM: x86: clear write_fault_to_shadow_pgtable explicitly
> 
> Clear it explicitly when exiting x86_emulate_instruction to clarify the code,
> it is suggested by Marcelo
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)

Fine, please rebase against queue.

