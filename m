Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaDFRCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:02:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44953 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754355AbaDFRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:02:05 -0400
Message-ID: <53418889.2050002@free-electrons.com>
Date: Sun, 06 Apr 2014 19:02:01 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Kconfig ARM_ERRATA_753970?
References: <201404052101.19381.arnd@arndb.de>	 <201404052104.11363.arnd@arndb.de> <1396777049.30640.9.camel@x220>
In-Reply-To: <1396777049.30640.9.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 06/04/2014 11:37, Paul Bolle wrote:
> On Sat, 2014-04-05 at 20:04 +0100, Arnd Bergmann wrote:
>> Gregory CLEMENT (1):
>>       ARM: mvebu: add initial support for the Armada 375 SOCs
>>
>> [...]
>>
>> Thomas Petazzoni (7):
>>       [...]
>>       ARM: mvebu: add initial support for the Armada 380/385 SOCs
> 
> These two commits added select statements for ARM_ERRATA_753970. But I
> couldn't find that Kconfig symbol. (I checked master of Linus' tree and
> current linux-next.) So it seems it was intended to select
> PL310_ERRATA_753970 here. Is that correct?

Yes it is correct. ARM_ERRATA_753970 was renamed to PL310_ERRATA_753970
in kernel 3.2. I had just carry on the symbol name without noticed that
it have changed.

Do you want to send a fix, or do you prefer I take care of it?


Thanks,

Gregory


> 
> 
> Paul Bolle
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
