Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaIARC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:02:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55253 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaIARCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:02:55 -0400
Message-ID: <5404A66E.509@zytor.com>
Date: Mon, 01 Sep 2014 10:01:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>
CC: eparis@redhat.com, paulmck@linux.vnet.ibm.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, zhenglong.cai@cs2c.com.cn,
        khilman@linaro.org, ak@linux.intel.com, mcgrof@suse.com,
        fabf@skynet.be, "dhowells@redhat.com" <dhowells@redhat.com>,
        pefoley2@pefoley.com, mgorman@suse.de, biederm@xmission.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] init/Kconfig: Add ENDIAN attributes for all architectures
 using
References: <540494D6.40701@gmail.com> <20140901160828.GJ26632@windriver.com>
In-Reply-To: <20140901160828.GJ26632@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 09:08 AM, Paul Gortmaker wrote:
>>>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index ac033c3..f301cc8 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -23,6 +23,12 @@ config CONSTRUCTORS
>>  config IRQ_WORK
>>  	bool
>>  
>> +config CPU_LITTLE_ENDIAN
>> +	bool
>> +
>> +config CPU_BIG_ENDIAN
>> +	bool
> 
> Perhaps you should take a cursory look at what already exists in tree
> before blindly trying to add more to it?
> 
> $ git grep CPU_BIG_ENDIAN | wc -l
> 88
> 

The whole point of this patchset is to make these already widely-used
options universal across the tree.

	-hpa


