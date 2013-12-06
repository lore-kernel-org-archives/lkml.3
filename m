Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3LFAGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:06:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:30695 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab3LFAGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:06:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,837,1378882800"; 
   d="scan'208";a="325960012"
Message-ID: <52A11604.8000702@linux.intel.com>
Date: Thu, 05 Dec 2013 16:10:44 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mmarek@suse.cz, rostedt@goodmis.org
Subject: Re: make oldnoconfig fix?
References: <1386039493.1974.305@driftwood>
In-Reply-To: <1386039493.1974.305@driftwood>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 06:58 PM, Rob Landley wrote:
> On 11/11/2013 12:55:37 PM, David Cohen wrote:
>> On 11/11/2013 10:13 AM, Yann E. MORIN wrote:
>>> David, All,
>>
>> Hi Yann,
>>
>>>
>>> On 2013-11-11 10:11 -0800, David Cohen spake thusly:
>>>> Is there a plan to fix 'make oldnoconfig' option?
>>>> I currently have need to it :)
>>>> I've tracked a thread fixing 'make olddefconfig' where 'oldnoconfig'
>>>> option is reported as a known bug, right?
>>>
>>> Sorry, I don't understand what your problem is.
>>
>> Maybe I assumed it was more 'known' then it actually is :)
>>
>>>
>>> Care to explain in details what problem you have:
>>>    - what you start with
>>>    - what you do
>>>    - what you get
>>>    - what you expected
>>
>> The bug with 'oldnoconfig' is: 'make oldnoconfig' is just an alias to
>> 'olddefconfig'. Any non-existent config is defined with its default
>> value instead of 'N'.
>>
>> I work with embedded platforms. I need to maintain a set of defconfigs
>> for different products (customers some times want tailored configs, so
>> creating a generic one isn't an option always).
> 
> make allnoconfig KCONFIG_ALLCONFIG=oldconfigfile

I'll give it a try. Thanks!

> 
> I use this trick in http://landley.net/aboriginal/FAQ.html#dev_miniconfig
> 
> And yes, I submitted it upstream a couple times last decade, with
> documentation and everything:

You could send it again.
But maybe oldnoconfig would be a better name WRT current standard.

Br, David

> 
>   https://lwn.net/Articles/160497/
>   https://lwn.net/Articles/161086/
>   http://lkml.indiana.edu/hypermail/linux/kernel/0607.0/1805.html
> 
> Rob

