Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3F0KPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:15:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:3440 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3F0KPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:15:02 -0400
X-Spam-Score: -100.9
Message-ID: <51CC1071.5040802@asianux.com>
Date: Thu, 27 Jun 2013 18:14:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-m32r-ja@ml.linux-m32r.org" <linux-m32r-ja@ml.linux-m32r.org>,
        "linux-m32r@ml.linux-m32r.org" <linux-m32r@ml.linux-m32r.org>
Subject: Re: [PATCH] include/asm-generic/pci.h: include generic "pci-dma-compat.h"
References: <51CBB98D.3040304@asianux.com> <20130627082920.GA14335@darko.cambridge.arm.com>
In-Reply-To: <20130627082920.GA14335@darko.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 04:29 PM, Catalin Marinas wrote:
> On Thu, Jun 27, 2013 at 05:03:25AM +0100, Chen Gang wrote:
>> > If an architecture need "generic pci.h", it also need generic "pci-dma-
>> > compat.h",  so recommend to include it in asm-generic directly.
>> > 
>> > And now, for arm64 and m32r, may cause compiling error about it.
>> > 
>> > The related error (with allmodconfig):
>> > 
>> >   drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_exit’:
>> >   drivers/media/usb/b2c2/flexcop-usb.c:393:3: error: implicit declaration of function ‘pci_free_consistent’ [-Werror=implicit-function-declaration]
>> >   drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_init’:
>> >   drivers/media/usb/b2c2/flexcop-usb.c:410:2: error: implicit declaration of function ‘pci_alloc_consistent’ [-Werror=implicit-function-declaration]
>> >   drivers/media/usb/b2c2/flexcop-usb.c:410:21: warning: assignment makes pointer from integer without a cast [enabled by default]
>> >   cc1: some warnings being treated as errors
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> From the arm64 perspective:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 

Thanks.

> (but make sure it doesn't break other archs)

I will try to check all related archs with allmodconfig (which can also
find more another patches, and can let me familiar the compiler step by
step).  ;-)


Thanks.
-- 
Chen Gang
