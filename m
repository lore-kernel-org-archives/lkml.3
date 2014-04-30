Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaD3Hpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:45:34 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48173 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaD3Hpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:45:32 -0400
Message-ID: <5360AA15.9060006@gmail.com>
Date: Wed, 30 Apr 2014 19:45:25 +1200
From: Michael Schmitz <schmitzmic@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Finn Thain <fthain@telegraphics.com.au>, scsi <linux-scsi@vger.kernel.org>,
        Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, Joe Perches <joe@perches.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH v2 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
References: <20140319123516.542623278@telegraphics.com.au>  <1398532863.24466.2.camel@dabdike.int.hansenpartnership.com>  <alpine.LNX.2.00.1404291202190.32739@nippy.intranet>  <CAOmrzk+kuepC7QR4uchP_zxk7-Bi7faiF-Z5jGX9KMcHn-7_9Q@mail.gmail.com> <1398782476.2218.20.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1398782476.2218.20.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,
> Perhaps Michael and Sam would be interested in sharing the role, for atari
> and sun3 NCR5380 drivers (?)
>> If you insist ...
>>
>> (kidding - I"m OK with it if James thinks it's worth it)
> As long as you understand how it works and how to fix it, the more the
> merrier.  It gives me more people to yell at if something goes wrong
> with the driver.

I used to have a fair understanding of the Atari driver years back - 
just need to get my head around all the midlevel and error handling 
changes since.

You'll be yelling at me regarding any breakage in the Atari NCR5380 
driver anyway in the end - count me in.

Cheers,

     Michael

