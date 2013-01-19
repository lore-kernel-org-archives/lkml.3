Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3ASBPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:15:25 -0500
Received: from solarsail.media.mit.edu ([18.85.2.155]:54251 "EHLO
	solarsail.media.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3ASBPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:15:03 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2013 20:15:03 EST
Message-ID: <50F9F152.1000907@laptop.org>
Date: Fri, 18 Jan 2013 15:05:22 -1000
From: Mitch Bradley <wmb@laptop.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Andres Salomon <dilinger@queued.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@in.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, techteam@lists.laptop.org,
        Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Techteam] [RFC PATCH] x86-32: Start out eflags and cr4 clean
References: <87sjaaj3cx.fsf@xmission.com> <1348529239-17943-1-git-send-email-hpa@linux.intel.com> <20121010125927.0968dd8b@dev.queued.net> <20130118164043.29674d75@dev.queued.net> <50F9EBEA.9020805@linux.intel.com>
In-Reply-To: <50F9EBEA.9020805@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/18/2013 2:42 PM, H. Peter Anvin wrote:
> On 01/18/2013 04:40 PM, Andres Salomon wrote:
>> Bad news on this patch; I've been told that it breaks booting on an
>> XO-1.5.  Does anyone from OLPC know why yet?
> 
> What are the settings of CR0 and CR4 on kernel entry on XO-1.5?


CR0 is 0x80000011
CR4 is 0x10

> 
> 	-hpa
> 
> 
> _______________________________________________
> Techteam mailing list
> Techteam@lists.laptop.org
> http://lists.laptop.org/listinfo/techteam
> 
