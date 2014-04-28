Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbaD1OPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:15:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358AbaD1OPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:15:45 -0400
Date: Mon, 28 Apr 2014 16:15:33 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@kernel.org>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: async_pf: use_mm/mm_users fixes
Message-ID: <20140428141532.GD10488@redhat.com>
References: <20140421132543.GA13594@redhat.com>
 <535E361D.3050902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E361D.3050902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 01:06:05PM +0200, Paolo Bonzini wrote:
> Patch 1 will be for 3.16 only, I'd like a review from Marcelo or Andrea 
> though (that's "KVM: async_pf: kill the unnecessary use_mm/unuse_mm 
> async_pf_execute()" for easier googling).

Patch 1:

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

I think current->NULL would be better too.

