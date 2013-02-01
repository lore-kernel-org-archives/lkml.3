Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3BAGmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:42:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50029 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3BAGmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:42:08 -0500
Message-ID: <510B629C.1010605@zytor.com>
Date: Thu, 31 Jan 2013 22:37:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>, hyojun.im@lge.com,
        raphael.andy.lee@gmail.com, linux-kbuild@vger.kernel.org,
        gunho.lee@lge.com, namhyung.kim@lge.com, x86@kernel.org,
        minchan.kim@lge.com, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Ingo Molnar <mingo@redhat.com>, Joe Millenbach <jmillenbach@gmail.com>,
        chan.jeong@lge.com, Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130128142510.68092e10.akpm@linux-foundation.org> <20130129101549.GP23505@n2100.arm.linux.org.uk> <51089523.3080804@zytor.com> <alpine.LFD.2.02.1301301326530.6300@xanadu.home> <510AE6BF.4080303@zytor.com> <alpine.LFD.2.02.1301311700470.6300@xanadu.home> <510AEDC2.80107@zytor.com> <alpine.LFD.2.02.1301312117240.6300@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1301312117240.6300@xanadu.home>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 06:28 PM, Nicolas Pitre wrote:
>>
>> Well, it is too nasty for public confession, but it's called
>> "paravirtualization".
> 
> The fact that you are aware of it means we're not going to break them.  
> 
> But my point is that we must not be held back just in case someone out 
> there might have painted himself in a corner without telling anyone.
> 

Yes.  However, it makes it more questionable to simply rip out
compression methods without warning.  Not that warnings help, as we have
learned.

	-hpa


