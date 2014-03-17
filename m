Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbaCQLSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:18:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45712 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQLSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:18:17 -0400
Message-ID: <5326D9F5.2050807@redhat.com>
Date: Mon, 17 Mar 2014 12:18:13 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests 0/2] test MOVAPS and MOVAPD SSE instructions
References: <1394913818-6616-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1394913818-6616-1-git-send-email-imammedo@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/03/2014 21:03, Igor Mammedov ha scritto:
> This series adds checks for MOVAPS and MOVAPD SSE instructions.
> It's used by MS HCK test on 32-bit Windows 8.1
>
> Igor Mammedov (2):
>   emulator: movaps
>   emulator: movapd
>
>  x86/emulator.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>

Applied both, thanks.

Paolo
