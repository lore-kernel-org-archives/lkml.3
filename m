Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaAQPIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:08:02 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34361 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbaAQPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:08:00 -0500
Date: Fri, 17 Jan 2014 15:07:25 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 resend 1/5] ARM: add support for AT_HWCAP2 ELF auxv
 entry
Message-ID: <20140117150725.GK16003@mudshark.cambridge.arm.com>
References: <1389950591-4212-1-git-send-email-ard.biesheuvel@linaro.org>
 <1389950591-4212-2-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389950591-4212-2-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ard,

On Fri, Jan 17, 2014 at 09:23:07AM +0000, Ard Biesheuvel wrote:
> This enables AT_HWCAP2 for ARM. The generic support for this
> new ELF auxv entry was added in commit 2171364d1a9 (powerpc:
> Add HWCAP2 aux entry)

Does this require a corresponding change in libc so that the entry is
actually used by the dynamic linker?

Will
