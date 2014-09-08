Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaIHDfJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 23:35:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:36812 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaIHDfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 23:35:08 -0400
Message-ID: <540D23E5.80208@infradead.org>
Date: Sun, 07 Sep 2014 20:35:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Pete Clements <clem@clem.clem-digital.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: 3.17-rc4 fails compile (arch/x86/pci/irq.c)
References: <201409080225.s882Pntx019152@clem.clem-digital.net> <1410145932.5157.3.camel@marge.simpson.net>
In-Reply-To: <1410145932.5157.3.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/14 20:12, Mike Galbraith wrote:
> (adds CC)
> 
> On Sun, 2014-09-07 at 22:25 -0400, Pete Clements wrote: 
>> Fyi: i386 up  -- problem introduced in rc3.
>>
>>   CC      arch/x86/pci/irq.o
>> arch/x86/pci/irq.c: In function 'pirq_disable_irq':
>> arch/x86/pci/irq.c:1259:2: error: implicit declaration of function 'mp_should_keep_irq' [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>> make[1]: *** [arch/x86/pci/irq.o] Error 1
>> make: *** [arch/x86/pci] Error 2

fix is at:
http://marc.info/?l=linux-kernel&m=140938277815528&w=2


-- 
~Randy
