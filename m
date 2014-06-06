Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaFFIEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:04:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbaFFIEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:04:49 -0400
Message-ID: <5391760E.2030401@redhat.com>
Date: Fri, 06 Jun 2014 10:04:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests 0/2] x86: Additional smsw tests
References: <53908C66.20600@redhat.com> <1402012613-29891-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1402012613-29891-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/06/2014 01:56, Nadav Amit ha scritto:
> This patch set adds two tests for smsw. The first one is intended to add
> coverage of smsw. It covers the case smsw is executed with memory operand in a
> page which is write-protected by the hypervisor. Note that the existing smsw
> tests are not supposed to be trapped by the hypervisor. This test was added
> just for additional coverage.
>
> The realmode smsw test covers the recent patch that saves the high 16-bits to
> 32-bit register operand. Implementing a long-mode test is difficult since we
> need to cause an "invalid guest state" in long-mode.

You can use emulator.flat to test the emulator in long mode.

See test_movabs for an example.

Paolo

> Nadav Amit (2):
>   x86: emulator: additional smsw test-case
>   x86: realmode: test smsw behavior with register operand
>
>  x86/emulator.c | 10 ++++++++--
>  x86/realmode.c | 15 +++++++++++++++
>  2 files changed, 23 insertions(+), 2 deletions(-)
>

