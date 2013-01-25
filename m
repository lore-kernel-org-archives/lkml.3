Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3AYAXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:23:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab3AYAWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:22:54 -0500
Date: Thu, 24 Jan 2013 22:15:50 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 06/12] KVM: MMU: introduce a static table to map guest
 access to spte access
Message-ID: <20130125001550.GB22875@amt.cnet>
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
 <50FFB658.6040205@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFB658.6040205@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 06:07:20PM +0800, Xiao Guangrong wrote:
> It makes set_spte more clean and reduces branch prediction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   37 ++++++++++++++++++++++++++-----------
>  1 files changed, 26 insertions(+), 11 deletions(-)

Don't see set_spte as being a performance problem?
IMO the current code is quite simple.



