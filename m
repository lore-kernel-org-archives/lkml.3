Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3D0PIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:08:47 -0400
Received: from yourcmc.ru ([195.24.71.121]:57609 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab3D0PIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:08:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 27 Apr 2013 19:08:42 +0400
From: vitalif@yourcmc.ru
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>, Ben Hutchings <ben@decadent.org.uk>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        <700333@bugs.debian.org>, LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: Bug#700333: Stack trace
In-Reply-To: <alpine.LFD.2.02.1304251139340.21884@ionos>
References: <4bded8a24b0719d575f6ffa6b38aebb6@yourcmc.ru>
 <1362490501.3768.409.camel@deadeye.wl.decadent.org.uk>
 <1b81bc6219ee47a5b8e53d03e9944939@yourcmc.ru>
 <20130305203952.GZ9079@decadent.org.uk>
 <4e8c511dcfd811c0f2ab822adaf52e50@yourcmc.ru>
 <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk>
 <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru>
 <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk>
 <cc9020446ea75ed733ec96c505039f2a@yourcmc.ru>
 <20130420225516.GB4649@pd.tnic> <alpine.LFD.2.02.1304221409420.21884@ionos>
 <alpine.LFD.2.02.1304251139340.21884@ionos>
Message-ID: <2666050d6d50efdbfa3503aa10c0e5ec@yourcmc.ru>
User-Agent: Roundcube Webmail/0.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks like we can't do anything about that in the HPET code itself.
>
> Vitaliy, could you try that patch ?

Thanks, I've tried it several days ago (and still using a patched 
kernel :)) - the box survives.
But at which moment should I check for "Spurious interrupt" in dmesg?
