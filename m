Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3LCC6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:58:20 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58359 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3LCC6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:58:18 -0500
Date: Mon, 02 Dec 2013 20:58:13 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: make oldnoconfig fix?
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mmarek@suse.cz, rostedt@goodmis.org
In-Reply-To: <52812829.4080508@linux.intel.com> (from
	david.a.cohen@linux.intel.com on Mon Nov 11 12:55:37 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1386039493.1974.305@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 12:55:37 PM, David Cohen wrote:
> On 11/11/2013 10:13 AM, Yann E. MORIN wrote:
>> David, All,
> 
> Hi Yann,
> 
>> 
>> On 2013-11-11 10:11 -0800, David Cohen spake thusly:
>>> Is there a plan to fix 'make oldnoconfig' option?
>>> I currently have need to it :)
>>> I've tracked a thread fixing 'make olddefconfig' where 'oldnoconfig'
>>> option is reported as a known bug, right?
>> 
>> Sorry, I don't understand what your problem is.
> 
> Maybe I assumed it was more 'known' then it actually is :)
> 
>> 
>> Care to explain in details what problem you have:
>>    - what you start with
>>    - what you do
>>    - what you get
>>    - what you expected
> 
> The bug with 'oldnoconfig' is: 'make oldnoconfig' is just an alias to
> 'olddefconfig'. Any non-existent config is defined with its default
> value instead of 'N'.
> 
> I work with embedded platforms. I need to maintain a set of defconfigs
> for different products (customers some times want tailored configs, so
> creating a generic one isn't an option always).

make allnoconfig KCONFIG_ALLCONFIG=oldconfigfile

I use this trick in  
http://landley.net/aboriginal/FAQ.html#dev_miniconfig

And yes, I submitted it upstream a couple times last decade, with  
documentation and everything:

   https://lwn.net/Articles/160497/
   https://lwn.net/Articles/161086/
   http://lkml.indiana.edu/hypermail/linux/kernel/0607.0/1805.html

Rob