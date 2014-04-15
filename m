Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaDORg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:36:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55559 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaDORgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:36:54 -0400
Message-ID: <534D6E32.3020003@infradead.org>
Date: Tue, 15 Apr 2014 10:36:50 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>, Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: Hardware dependencies in Kconfig
References: <20140414145359.48b7337c@endymion.delvare>	<20140414191143.GA26864@kroah.com>	<20140414231254.392c0df8@endymion.delvare>	<20140415045214.GA32541@kroah.com> <20140415125413.302d1ce1@endymion.delvare>
In-Reply-To: <20140415125413.302d1ce1@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 03:54 AM, Jean Delvare wrote:
> Hi Greg,
> 
> On Mon, 14 Apr 2014 21:52:14 -0700, Greg KH wrote:
>> On Mon, Apr 14, 2014 at 11:12:54PM +0200, Jean Delvare wrote:
> 
>> I do 'allmodconfig'
>> builds all the time, with over 3000 modules.  The build works just fine
>> on "modern" hardware.
> 
>> I'd argue that your build systems need to get faster, the laptop I'm
>> typing this on can do a full modconfig build, with over 3000 modules, in
>> around 20 minutes.  My build server in the cloud can do that in less
>> than 5 minutes, and that's not a very fast machine these days.
> 
> Electricity isn't free, hardware isn't free, rack slot count is finite
> and server room space is limited over here.
> 
> I don't quite see why we should invest in new hardware to shorten the
> build times, if the same can be achieved with our current hardware
> simply with better configuration files. Plus there is no reason to
> choose between the two. We can have new hardware _and_ better configs
> and improve the build times further :-) So your proposal is off-topic
> to some degree.
> 
> And really, I don't see why I should have to wait for 10 minutes for my
> build to complete if half of that is spent building drivers that will
> never be used. The fact that 10 minutes is "reasonable" is irrelevant.
> 
> Of course, if the Linux Foundation, or you personally, are willing to
> buy me a brand new workstation with more CPU power than I currently
> have, I'll gladly accept. You can also donate your powerful laptop to
> the OBS project, they'll be happy to add it to their build farm ;-)

hey, over here also...
I'd like a new fast laptop that does decent allmodconfig build times.  :)
[e.g., a core i7 cpu and ssd and lots of RAM]

-- 
~Randy
