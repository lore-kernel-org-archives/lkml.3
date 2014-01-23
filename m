Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbaAWPB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:01:58 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55685 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753817AbaAWPB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:01:57 -0500
Date: Thu, 23 Jan 2014 15:01:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 resend 0/5] arm64: advertise availability of CRC and
 crypto instructions
Message-ID: <20140123150123.GH27520@arm.com>
References: <1389950591-4212-1-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389950591-4212-1-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 09:23:06AM +0000, Ard Biesheuvel wrote:
> Ard Biesheuvel (5):
>   ARM: add support for AT_HWCAP2 ELF auxv entry
>   binfmt_elf: add ELF_HWCAP2 to compat auxv entries
>   arm64: add AT_HWCAP2 support for 32-bit compat
>   ARM: introduce HWCAP2 feature bits for ARMv8 Crypto Extensions
>   arm64: advertise ARMv8 extensions to 32-bit compat ELF binaries

I think I acked this series but probably after you posted the resend.
Just in case I haven't:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
