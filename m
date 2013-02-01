Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3BAQ6C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:58:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58405 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab3BAQ6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:58:00 -0500
Message-ID: <510BF3F1.2050605@zytor.com>
Date: Fri, 01 Feb 2013 08:57:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: Phil Turmel <philip@turmel.org>, paul.szabo@sydney.edu.au,
        ben@decadent.org.uk, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: PAE problems was [RFC] Reproducible OOM with just a few sleeps
References: <201302010313.r113DTj3027195@como.maths.usyd.edu.au> <510B46C3.5040505@turmel.org> <20130201102044.GA2801@amd.pavel.ucw.cz> <20130201102545.GA3053@amd.pavel.ucw.cz>
In-Reply-To: <20130201102545.GA3053@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 02:25 AM, Pavel Machek wrote:
>
> On Fri 2013-02-01 11:20:44, Pavel Machek wrote:
>> On Thu 2013-01-31 23:38:27, Phil Turmel wrote:
>>> On 01/31/2013 10:13 PM, paul.szabo@sydney.edu.au wrote:
>>>> [trim /] Does not that prove that PAE is broken?
>>>
>>> Please, Paul, take *yes* for an answer.  It is broken.  You've received
>>> multiple dissertations on why it is going to stay that way.  Unless you
>>> fix it yourself, and everyone seems to be politely wishing you the best
>>> of luck with that.
>>
>> It is not Paul's job to fix PAE. It is job of whoever broke it to do
>> so.
>>
>> If it is broken with 2GB of RAM, it is clearly not the known "lowmem
>> starvation" issue, it is something else... and probably worth
>> debugging.
>>
>> So, Paul, if you have time and interest... Try to find some old kernel
>> version where sleep test works with PAE. Hopefully there is one. Then
>> do bisection... author of the patch should then fix it. (And if not,
>> at least you have patch you can revert.)
>>
>> rjw is worth cc-ing at that point.
>
> Ouch, and... IIRC (hpa should know for sure), PAE is neccessary for
> R^X support on x86, thus getting more common, not less. If it does not
> work, that's bad news.
>
> Actually, if PAE is known broken, it should probably get marked as
> such in Kconfig. That's sure to get some discussion started...
> 									Pavel
>

OK, so by the time this thread gets to me there is of course no 
information in it.

The vast majority of all 32-bit kernels compiled these days are PAE, so 
it would seem rather odd if PAE was totally broken.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

