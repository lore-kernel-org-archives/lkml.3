Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbaKUR1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:27:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbaKUR13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:27:29 -0500
Date: Fri, 21 Nov 2014 18:27:26 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: move ioapic.c and irq_comm.c back to arch/x86/
Message-ID: <20141121172725.GB16941@potion.brq.redhat.com>
References: <1416490931-21724-1-git-send-email-pbonzini@redhat.com>
 <20141121161956.GA16941@potion.brq.redhat.com>
 <546F70BF.30509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546F70BF.30509@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-21 18:05+0100, Paolo Bonzini:
> On 21/11/2014 17:19, Radim Krčmář wrote:
> > KVM: x86: remove IA64 from ioapic.c and irq_comm.c
> > 
> > They won't get compiled in x86 tree.
> 
> Ah no, these were already in my ia64 removal patch.  I had a deja-vu
> feeling...

Oops, renaming simplifies conflict resolution ...
CONFIG_X86 removal should still be applicable though.
