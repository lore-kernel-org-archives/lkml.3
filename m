Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaEGWbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:31:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53031 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaEGWbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:31:35 -0400
Message-ID: <536AB445.60308@infradead.org>
Date: Wed, 07 May 2014 15:31:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Tree for May 7 (argh)
References: <20140507173341.753d8ccf4fe033abd513f98f@canb.auug.org.au>	<536A9CF2.90906@infradead.org> <20140508075606.fd453d43546aef01b87e3ad1@canb.auug.org.au>
In-Reply-To: <20140508075606.fd453d43546aef01b87e3ad1@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 02:56 PM, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Wed, 07 May 2014 13:52:02 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> I was away for one week.  Did I miss some new instructions about
>> building linux-next?
> 
> Nothing that I know of.
> 
>>
>> I get a thousands of messages like these:
> 
> What config?  What arch?  Did you just do "make oldconfig"?

i386 and x86_64.  make randconfig 10 times on each.


>> WARNING: "system_wq" [drivers/misc/bh1770glc.ko] has no CRC!
>> WARNING: "__wake_up" [drivers/misc/bh1770glc.ko] has no CRC!
>> WARNING: "sysfs_notify" [drivers/misc/bh1770glc.ko] has no CRC!
>> WARNING: "kfree" [drivers/misc/bh1770glc.ko] has no CRC!
>>
>> Also there hundreds of messages like these:
>>
>> ps2mult.c:(.exit.text+0x8f): multiple definition of `cleanup_module'
>> ps2mult.c:(.init.text+0xbc8): multiple definition of `init_module'
>> ipack.c:(.exit.text+0x0): multiple definition of `cleanup_module'
>> ipack.c:(.init.text+0x0): multiple definition of `init_module'
>> mcb-core.c:(.text+0x40d): multiple definition of `cleanup_module'
>> mcb-core.c:(.text+0x3fb): multiple definition of `init_module'
> 
> cc'ing Rusty just in case ...
> 


-- 
~Randy
