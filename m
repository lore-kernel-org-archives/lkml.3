Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaKJSEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:04:31 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaKJSE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:04:29 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <5460EF02.3000904@gmail.com>
References: <CA+r1Zhio+KeBH0FFHwj=_fTFjqzebeE7Y2O_vsvMco49Sp56jw@mail.gmail.com> <5460EF02.3000904@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: randconfig build error with next-20141110, in drivers/platform/x86/hp_accel.c
From: Darren Hart <dvhart@infradead.org>
Date: Mon, 10 Nov 2014 09:19:15 -0800
To: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>,
        Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        eric.piel@tremplin-utc.net, platform-driver-x86@vger.kernel.org
Message-ID: <56A55F6D-4EA5-4A54-8727-97D3E4A875A5@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On November 10, 2014 8:59:46 AM PST, Giedrius Statkevicius <giedrius.statkevicius@gmail.com> wrote:
>Hi Jim,
>
>On 2014.11.10 18:20, Jim Davis wrote:
>> Building with the attached random configuration file,
>> 
>> drivers/built-in.o: In function `lis3lv02d_remove':
>> /home/jim/linux/drivers/platform/x86/hp_accel.c:389: undefined
>> reference to `i8042_remove_filter'
>> drivers/built-in.o: In function `lis3lv02d_add':
>> /home/jim/linux/drivers/platform/x86/hp_accel.c:370: undefined
>> reference to `i8042_install_filter'
>> make: *** [vmlinux] Error 1
>> 
>
>Oops, sorry. Forgot to add a depend on i8042 per this patch in Kconfig:
>https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=a4c724d0723b078e4ab4670e557cda1795036a7a
>
>This patch should fix it. After applying and using your .config I
>compiled the kernel without those undefined references. Should I make a
>new thread where it's submitted in the proper form? 

Yes please.


-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
