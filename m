Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab3E0EHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 00:07:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57685 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3E0EHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 00:07:14 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv4 1/6] arm: TI-Nspire platform code
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201305262246.12803.arnd@arndb.de>
Date: Mon, 27 May 2013 14:07:05 +1000
Cc: linux-arm-kernel@lists.infradead.org,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3ED6FFF2-89E2-4426-8DDC-10B4E6C79F26@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <1369480087-24786-2-git-send-email-dt.tangr@gmail.com> <201305262246.12803.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27/05/2013, at 6:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> 
>> +	{
>> +		.virtual	=  NSPIRE_PWR_VIRT_BASE,
>> +		.pfn		= __phys_to_pfn(NSPIRE_PWR_PHYS_BASE),
>> +		.length		= SZ_4K,
>> +		.type		= MT_DEVICE
>> +	}
>> +};
> 
> And I think this one can be replaced with a call to of_iomap:

Does of_iomap work that early in the boot process?

Cheers,
Daniel Tang

