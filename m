Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaHNN5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbaHNN5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:57:42 -0400
Message-ID: <1408024516.599.134.camel@deneb.redhat.com>
Subject: Re: [PATCH 4/7] arm64/efi: uefi_init error handling fix
From: Mark Salter <msalter@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        Daniel Kiper <daniel.kiper@oracle.com>, Russ Anderson <rja@sgi.com>
Date: Thu, 14 Aug 2014 09:55:16 -0400
In-Reply-To: <1408007731-15081-4-git-send-email-dyoung@redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
	 <1408007731-15081-4-git-send-email-dyoung@redhat.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-14 at 17:15 +0800, Dave Young wrote:
> There's one early memmap leak in uefi_init error path, fix it and slightly tune
> the error handling code.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/arm64/kernel/efi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Acked-by: Mark Salter <msalter@redhat.com>


