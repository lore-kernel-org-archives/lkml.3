Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbaCQLSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:18:10 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53514 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQLSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:18:08 -0400
Message-ID: <5326D9EA.3070603@redhat.com>
Date: Mon, 17 Mar 2014 12:18:02 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE
 instructions
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/03/2014 21:01, Igor Mammedov ha scritto:
> MS HCK test fails on 32-bit Windows 8.1 due to missing MOVAPS
> instruction emulation, this series adds it and while at it,
> it adds emulation of MOVAPD which is trivial to implement on
> top of MOVAPS.
>
> Igor Mammedov (2):
>   KVM: x86 emulator: emulate MOVAPS
>   KVM: x86 emulator: emulate MOVAPD
>
>  arch/x86/kvm/emulate.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>

Applied both to kvm/next, thanks.

Paolo
