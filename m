Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaD1PCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:02:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775AbaD1PCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:02:48 -0400
Date: Mon, 28 Apr 2014 17:02:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@kernel.org>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/2] KVM: async_pf: change async_pf_execute() to use
	get_user_pages(tsk => NULL)
Message-ID: <20140428150234.GA19879@redhat.com>
References: <20140421132543.GA13594@redhat.com> <535E361D.3050902@redhat.com> <20140428141532.GD10488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428141532.GD10488@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Andrea Arcangeli wrote:
>
> On Mon, Apr 28, 2014 at 01:06:05PM +0200, Paolo Bonzini wrote:
> > Patch 1 will be for 3.16 only, I'd like a review from Marcelo or Andrea
> > though (that's "KVM: async_pf: kill the unnecessary use_mm/unuse_mm
> > async_pf_execute()" for easier googling).
>
> Patch 1:
>
> Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

Thanks,

> I think current->NULL would be better too.

OK, let me send the trivial one-liner then. I won't mind if you fold it
into 1/2, or I can resend it with this change included.

Oleg.

