Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804Ab3D3VEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:04:14 -0400
Received: from yourcmc.ru ([195.24.71.121]:58868 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933769Ab3D3VED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:04:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 01 May 2013 01:04:00 +0400
From: vitalif@yourcmc.ru
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>, Ben Hutchings <ben@decadent.org.uk>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        <700333@bugs.debian.org>, LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: Bug#700333: Stack trace
In-Reply-To: <alpine.LFD.2.02.1304282152220.21884@ionos>
References: <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk>
 <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru>
 <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk>
 <cc9020446ea75ed733ec96c505039f2a@yourcmc.ru>
 <20130420225516.GB4649@pd.tnic> <alpine.LFD.2.02.1304221409420.21884@ionos>
 <alpine.LFD.2.02.1304251139340.21884@ionos>
 <2666050d6d50efdbfa3503aa10c0e5ec@yourcmc.ru>
 <20130427154956.GC4358@pd.tnic>
 <925b81fa055e645546ae9d237eeb2ef4@yourcmc.ru>
 <20130428190541.GA2301@pd.tnic> <alpine.LFD.2.02.1304282152220.21884@ionos>
Message-ID: <9eab1d6a826bbd58d0b074f045a1c675@yourcmc.ru>
User-Agent: Roundcube Webmail/0.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I merged a slightly better fix, you all were on cc. It's going into
> 3.10 and it's tagged stable, so it will show up in stable kernels
> soon.

Thanks for the fix!
But where did you post it - on LKML?
(I didn't see it because I'm not subscribed to LKML?)
