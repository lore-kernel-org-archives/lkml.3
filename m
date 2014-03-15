Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbaCOWk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 18:40:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45546 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbaCOWkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 18:40:24 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE instructions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 15 Mar 2014 15:39:48 -0700
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org
Message-ID: <f9c71833-f869-440c-8ab1-cd1f81f2da3b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MOVAPS, MOVAPD, and MOVDQA are the same operation.  They may, architecturally, have different performance characteristics, but nothing that would affect an emulator.

On March 15, 2014 1:01:58 PM PDT, Igor Mammedov <imammedo@redhat.com> wrote:
>MS HCK test fails on 32-bit Windows 8.1 due to missing MOVAPS
>instruction emulation, this series adds it and while at it,
>it adds emulation of MOVAPD which is trivial to implement on
>top of MOVAPS.
>
>Igor Mammedov (2):
>  KVM: x86 emulator: emulate MOVAPS
>  KVM: x86 emulator: emulate MOVAPD
>
> arch/x86/kvm/emulate.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
