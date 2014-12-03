Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaLCOFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:05:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbaLCOFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:05:42 -0500
Date: Wed, 3 Dec 2014 15:00:37 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH 2/2] KVM: cpuid: set CPUID(EAX=0xd,ECX=1).EBX correctly
Message-ID: <20141203140036.GB26617@potion.brq.redhat.com>
References: <1417614030-1692-1-git-send-email-pbonzini@redhat.com>
 <1417614030-1692-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417614030-1692-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-03 14:40+0100, Paolo Bonzini:
> This is the size of the XSAVES area.  This completes guest support
> for XSAVES (with no support yet for supervisor states, i.e. XSS == 0
> always in guests for now).
> 
> Suggested-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
(The first one is ok too.)
