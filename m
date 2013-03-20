Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3CTXTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:19:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab3CTXTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:19:18 -0400
Date: Wed, 20 Mar 2013 17:35:34 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: correctly initialize the CS base on reset
Message-ID: <20130320203534.GA18530@amt.cnet>
References: <1363707026-19351-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363707026-19351-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 04:30:26PM +0100, Paolo Bonzini wrote:
> The CS base was initialized to 0 on VMX (wrong, but usually overridden
> by userspace before starting) or 0xf0000 on SVM.  The correct value is
> 0xffff0000, and VMX is able to emulate it now, so use it.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 8 +-------
>  arch/x86/kvm/vmx.c | 1 +
>  2 files changed, 2 insertions(+), 7 deletions(-)

Applied, thanks.

