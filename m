Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaCOWmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 18:42:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45562 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbaCOWmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 18:42:51 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE instructions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 15 Mar 2014 15:42:35 -0700
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org
Message-ID: <8569d2b4-0593-4f7a-859c-3848670f718d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stupid question... what instructions do NOT need emulsion in KVM? It would seem that at least anything that touches memory would?

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
