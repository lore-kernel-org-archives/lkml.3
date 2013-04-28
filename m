Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3D1N0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 09:26:12 -0400
Received: from yourcmc.ru ([195.24.71.121]:33057 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab3D1N0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 09:26:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 28 Apr 2013 17:26:07 +0400
From: vitalif@yourcmc.ru
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ben Hutchings <ben@decadent.org.uk>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        <700333@bugs.debian.org>, LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: Bug#700333: Stack trace
In-Reply-To: <20130427154956.GC4358@pd.tnic>
References: <20130305203952.GZ9079@decadent.org.uk>
 <4e8c511dcfd811c0f2ab822adaf52e50@yourcmc.ru>
 <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk>
 <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru>
 <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk>
 <cc9020446ea75ed733ec96c505039f2a@yourcmc.ru>
 <20130420225516.GB4649@pd.tnic> <alpine.LFD.2.02.1304221409420.21884@ionos>
 <alpine.LFD.2.02.1304251139340.21884@ionos>
 <2666050d6d50efdbfa3503aa10c0e5ec@yourcmc.ru>
 <20130427154956.GC4358@pd.tnic>
Message-ID: <925b81fa055e645546ae9d237eeb2ef4@yourcmc.ru>
User-Agent: Roundcube Webmail/0.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When you do a suspend/resume cycle.

OK, yes, I've found it there.

> The bug says "The photo shows a BUG in hrtimer_interrupt() after 
> making
> the hibernation image and while resuming the non-boot CPUs." so I'm
> guessing with Thomas' patch it suspends fine now?

Yeah, now I'm using a patched kernel and it's OK.

So, does it mean the problem is fixed by this patch or it's just 
confirmed and should be fixed by another one?
