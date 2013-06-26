Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3FZSAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:00:04 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:51794 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533Ab3FZSAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:00:02 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2013 14:00:02 EDT
Message-ID: <51CB2A09.8050906@akamai.com>
Date: Wed, 26 Jun 2013 13:51:05 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "shigekatsu.tateno@atmel.com" <shigekatsu.tateno@atmel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>  <20130625170205.GA21328@kroah.com> <1372181390.1245.68.camel@joe-AO722>  <20130625173840.GA8930@kroah.com> <1372183005.1245.72.camel@joe-AO722> <1372183389.1245.74.camel@joe-AO722>
In-Reply-To: <1372183389.1245.74.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 02:03 PM, Joe Perches wrote:
> (Using Jason Baron's most current email address)
>
> On Tue, 2013-06-25 at 10:56 -0700, Joe Perches wrote:
>> On Tue, 2013-06-25 at 10:38 -0700, Greg KH wrote:
>>> On Tue, Jun 25, 2013 at 10:29:50AM -0700, Joe Perches wrote:
>>>> a long needed extension to dev_dbg is to enable classes
>>>> of messages by level or mask.
>>>>
>>>> There are many existing macros like
>>>>
>>>> #define module_dbg(level, fmt, ...)
>>>> do {
>>>> 	if (level >= some_module_var)
>>>> 		debug_something(...);
>>>> } while (0)
>>>>
>>>> and
>>>>
>>>> #define module_dbg(mask, fmt, ...)
>>>> do {
>>>> 	if (mask & some_module_var)
>>>> 		debug_something(...)
>>>> } while (0)
>>>>
>>>> It'd be nice to consolidate those in dev_dbg
>>> I'd almost recommend that all of them just be removed, because most of
>>> them were only used for debugging the code the first time it was
>>> developed, right?  Only for very limited usages would this type of thing
>>> be needed.
>> Maybe, though that's hard to know with certainty.
>> How often module options are used isn't easy to find out.
>>
>> These forms are sometimes used to reduce object size.
> Hey Jason.  Your redhat.com address is out of date.
>
> If you're still interested in dynamic_debug, you should
> update your MAINTAINERS entry.
>
>

Hi Joe,

Thanks for asking - I'll send out a patch to update it.

Thanks,

-Jason



