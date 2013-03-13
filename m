Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab3CMKhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:37:08 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:44248 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756308Ab3CMKhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:37:01 -0400
Message-ID: <514056CB.6070808@mimc.co.uk>
Date: Wed, 13 Mar 2013 10:36:59 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Excessive ethernet interrupts on AM335x board
References: <513F4B58.1000204@mimc.co.uk> <CACTFLAPv=OGaWaz+BdPxr56e56c=cx8QYuc9TUK61Bk4WD5=vg@mail.gmail.com>
In-Reply-To: <CACTFLAPv=OGaWaz+BdPxr56e56c=cx8QYuc9TUK61Bk4WD5=vg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/13 10:32, Daniel Mack wrote:
> On Tue, Mar 12, 2013 at 4:35 PM, Mark Jackson <mpfj-list@mimc.co.uk> wrote:
>> I'm just fighting an issue with ethernet on our custom AM335x board:-
>>
>> # uname -a
>> Linux nanobone 3.9.0-rc2-00113-gd60f039 #139 Tue Mar 12 15:14:01 GMT 2013 armv7l GNU/Linux
>>
>> Every now and then, the whole unit slows to a crawl.  The only indication of any problem is:-
>>
>> (a) the serial tty port becomes much less responsive
>> (b) normal ping times jump from 1ms to >10sec (sometimes >20sec !!)
>> (c) the ethernet interrupt count rockets (see below)
>>
>> I've tried to force the problem by flood pinging from my PC.

<snip>

>> As you can see, when I stop the flood pings, the nfs link is now reported
>> as being lost.
> 
> I had the same problem. Please check this patch, I'm sure it will fix you issue:
> 
>   https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=d35162f89b8f00537d7b240b76d2d0e8b8d29aa0

Brilliant ... that's the one !!  

Cheers
Mark J.
