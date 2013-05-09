Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3EIMBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab3EIMBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:01:35 -0400
Date: Thu, 9 May 2013 15:01:32 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH v2 0/3] KVM: emulate AAM, XLAT, SALC
Message-ID: <20130509120132.GN12349@redhat.com>
References: <1368091971-5071-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368091971-5071-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:32:48AM +0200, Paolo Bonzini wrote:
> These three instructions are not emulated, but can be found in
> real mode code.
> 
> These are also good for stable, but they conflict before 3.9 and are
> not really useful since emulate_invalid_guest_state defaulted to false.
> So I'm not marking them for earlier releases.
> 
> Paolo Bonzini (3):
>   KVM: emulator: emulate AAM
>   KVM: emulator: emulate XLAT
>   KVM: emulator: emulate SALC
> 
Applied, thanks.

>  arch/x86/kvm/emulate.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> -- 
> 1.8.1.4

--
			Gleb.
