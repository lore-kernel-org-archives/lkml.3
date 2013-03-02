Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3CBXpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:45:31 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:52753 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CBXpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:45:30 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Mar 2013 18:45:29 EST
Message-ID: <51328D83.9030105@cesarb.net>
Date: Sat, 02 Mar 2013 20:38:43 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Paul Bolle <pebolle@tiscali.nl>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH V2] MAINTAINERS: Update SIMTEC file patterns, remove Vincent
 Sanders
References: <1362166088.2116.10.camel@joe-AO722>  <1362168132.2116.17.camel@joe-AO722>  <1362169225.20156.6.camel@x61.thuisdomein> <1362170264.2116.24.camel@joe-AO722>
In-Reply-To: <1362170264.2116.24.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 01-03-2013 17:37, Joe Perches escreveu:
> On Fri, 2013-03-01 at 21:20 +0100, Paul Bolle wrote:
>> On Fri, 2013-03-01 at 12:02 -0800, Joe Perches wrote:
>>> commit 85fd6d6 ("ARM: S3C2410: move mach-s3c2410/* into mach-s3c24xx/")
>>> moved the files, update the F: patterns.
>>
>> The BAST MAINTAINER entry has come up a few times already. I commented
>> on the last time that happened in https://lkml.org/lkml/2012/11/24/96 .
>> Nothing has changed. I suggest to remove this entry entirely.
>
> Seems sensible to me.  Ben?
>
> I'm a bit surprised that all of Cesar Eduardo Barros' patches
> to MAINTAINERS weren't applied.  I thought they were.  It
> seems that only some of them are in.
>
> https://lkml.org/lkml/2012/11/23/439
>
> Cesar?  Can you please resend whatever scraps weren't applied
> and make sure you cc Andrew Morton?

I just checked on my local tree, and it is only the BAST one. For some 
reason, Andrew Morton did not add that one to his tree (probably because 
there was discussion about removing the whole block instead of fixing 
it, so he prefered to take the uncontroversial ones only).

The ones which were not in Andrew's tree all went in via other trees.

It might be best for me to make a new series instead. My 
checkmaintainers.py already gives me 15 lines of output, and that is on 
top of what I have pending (BAST and part 2 of the uapi mess) rebased 
over the Linus tree. On the Linus tree, it gives me 42 lines of output.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
