Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaFEPEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:04:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49211 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaFEPEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:04:43 -0400
Message-ID: <539086F6.8000004@zytor.com>
Date: Thu, 05 Jun 2014 08:04:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] KVM: x86: smsw emulation is incorrect in 64-bit mode
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il> <1401723251-8034-10-git-send-email-namit@cs.technion.ac.il> <53908467.8030100@redhat.com> <CB894343-EC15-4A5D-B461-B012FC19FC3A@gmail.com>
In-Reply-To: <CB894343-EC15-4A5D-B461-B012FC19FC3A@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 08:02 AM, Nadav Amit wrote:
>> I'm sorry, I'm missing the place where 64-bit mode is taken into account?
> It is not, since on 32-bit mode the high-order 16 bits of a register destination are undefined. 
> If I recall correctly, in this case the high-order 16-bits on native
system actually reflect the high-order 16-bits of CR0.

This sounds like something that really should be verified
experimentally.  The above claim seems... odd.

	-hpa


