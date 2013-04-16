Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407Ab3DPVXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 17:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965331Ab3DPVXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 17:23:01 -0400
Date: Tue, 16 Apr 2013 18:22:46 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gnatapov@redhat.com, jan.kiszka@siemens.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] kvm: nVMX: check vmcs12 for valid activity state
Message-ID: <20130416212246.GA21566@amt.cnet>
References: <1366030827-5662-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366030827-5662-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 03:00:27PM +0200, Paolo Bonzini wrote:
> KVM does not use the activity state VMCS field, and does not support
> it in nested VMX either (the corresponding bits in the misc VMX feature
> MSR are zero).  Fail entry if the activity state is set to anything but
> "active".
> 
> Since the value will always be the same for L1 and L2, we do not need
> to read and write the corresponding VMCS field on L1/L2 transitions,
> either.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Applied, thanks.

