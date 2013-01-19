Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3ASMvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 07:51:54 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:34026 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3ASMvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 07:51:53 -0500
Message-ID: <50FA96E0.2040604@kernel.org>
Date: Sat, 19 Jan 2013 12:51:44 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Getz, Robin" <robin.getz@analog.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Alessandro Rubini <rubini@gnudd.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "christophe.leroy@c-s.fr" <christophe.leroy@c-s.fr>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "patrick.vasseur@c-s.fr" <patrick.vasseur@c-s.fr>
Subject: Re: [PATCH] IIO ADC support for AD7923
References: <50F199F7.7020600@metafoo.de> <20130117171100.GA24398@mail.gnudd.com> <50F83695.506@metafoo.de> <201301181802.14382.robin.getz@analog.com>
In-Reply-To: <201301181802.14382.robin.getz@analog.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 11:02 PM, Getz, Robin wrote:
> On Thu 17 Jan 2013 12:36, Lars-Peter Clausen pondered:
>> On 01/17/2013 06:11 PM, Alessandro Rubini wrote:
>>> [...]
>>>
>>> But yes, you are right. I'm working on another I/O subsystem. We are
>>> gong to release zio-1.0 in a few days, because the thing is mature
>>> and used in production.
> 
> Neither means it's a good idea for upstream :)
> 
>> Still it's a very bad idea to have two subsystem which have a huge overlap
>> in both functionality and targeted devices. It will gives us all lots of
>> headaches later on. As IIO continues to evolve it will get support for some
>> of the features that only ZIO supports at the moment and as ZIO grows it
>> will get support for features currently only supported by IIO. So in the
>> end we have two frameworks for the very same purpose.
> 
> I want to strongly agree with Lars-Peter. Lets work together on one thing - 
> which tries to solve all the our system level issues. As an end user - I 
> don't want to re-write userspace for multiple interfaces to the same 
> underlying ADC/DACs.
> 
> I don't know how Greg feels about another subsystem in the kernel which 
> duplicates existing functionality/targetted devices - but it doesn't sound 
> like a good idea to me.
> 
>>> I hope to meet you in person at fosdem and be able to talk over a beer
>>> or two.
>>
>> Looking forward to meeting you :)
> 
> Hopefully you can come to some logical conclusions over a friendly beverage. 
> Even if you can't decide on how to merge things (plan for adding missing 
> features from one to the other), maybe it's just deciding on how to get as 
> much reuse as possible (duplication of device register and bit definitions?)
> 

I second these comments from Lars and Robin (or third I suppose ;).
Lets get the best possible result. The source of an idea or code
really doesn't matter in the long run, what matters is that we
get a solution that works well for all users.

Enjoy those beverages (and fosdem of course!)

Jonathan
