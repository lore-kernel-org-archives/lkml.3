Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735AbaGXWZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:25:29 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38730 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaGXWZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:25:27 -0400
Message-ID: <53D18824.9000907@gmail.com>
Date: Thu, 24 Jul 2014 18:26:44 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Martin Kepplinger <martink@posteo.de>, Zhang Rui <rui.zhang@intel.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [BUG] rc1 rc2 rc3 not bootable - black screen after kernel loading
References: <53A6E72A.9090000@posteo.de>	 <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>	 <53A81BF7.3030207@posteo.de> <1403529246.4686.6.camel@rzhang1-toshiba>	 <53A83DC7.1010606@posteo.de> <1403882067.16305.124.camel@rzhang1-toshiba>	 <53ADB359.4010401@posteo.de> <53ADCB24.9030206@posteo.de>	 <53ADECDA.60600@posteo.de> <53B11749.3020902@posteo.de>	 <1404116299.8366.0.camel@rzhang1-toshiba> <1404116444.8366.1.camel@rzhang1-toshiba> <53B12723.4080902@posteo.de> <53B13E4B.2080603@posteo.de> <53D131E7.2090304@posteo.de>
In-Reply-To: <53D131E7.2090304@posteo.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Kepplinger wrote:
> Am 2014-06-30 12:39, schrieb Martin Kepplinger:
>> back to aaeb2554337217dfa4eac2fcc90da7be540b9a73 as the first bad
>> commit. why is this not revertable exactly? how can I show a complete
>> list of commits this merge introduces?
>>
> It seems that _nobody_ is running a simple 32 bit i915 (acer) laptop.
> rc6 is still unusable. Black screen directly after kernel-loading. no
> change since rc1.
>
> Seems like I won't be able to use 3.16. I'm happy to test patches and am
> happy for any advice what to do, when time permits.
>
>                               martin
>
Martin, I am running happily a 32-bit kernel 3.16-rc*all on i915 (Asus 
EeePC)
However: from your postings I still have no idea what Intel video 
chipset is in your Acer.
Try to add "nomodeset=y" to your kernel's cmdline to verify that it can 
boot. You have many kobject messages which are hiding what is 
happening... And please submit at least full dmesg output and "lspci 
-nn" ;-)

Woody
