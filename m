Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaDBFmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:42:06 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38951 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaDBFmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:42:04 -0400
Message-ID: <533BA328.8090807@gmail.com>
Date: Wed, 02 Apr 2014 01:42:00 -0400
From: Alexandre Demers <alexandre.f.demers@gmail.com>
Reply-To: alexandre.f.demers@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: alexandre.f.demers@gmail.com
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Regression, bisected 9e30cc] "sysfs, kernfs: no need to kern_mount()
 sysfs from sysfs_init()" prevents system from booting correctly
References: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com> <20140314140804.GG12613@htj.dyndns.org> <CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com> <20140317201346.GE17373@mtj.dyndns.org> <5327AAA8.2080703@gmail.com> <53322777.3030703@gmail.com> <20140326131800.GA7171@htj.dyndns.org> <CAPEhTTGyA7SjedwL8Mv-ZDEY_doucW3thPr==xyOemm3+Vp=Cg@mail.gmail.com> <20140329181258.GF5553@htj.dyndns.org> <5337445E.3080903@gmail.com> <20140330123128.GB8942@htj.dyndns.org> <53384C24.6000309@gmail.com>
In-Reply-To: <53384C24.6000309@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should have a qemu image running before the end of the week based on 
the latest Archlinux 64 packages. Then, I'll install the 3.14 kernel 
and see what I'll get.

By the way, since kernel 3.14 is now available, it has been pushed to 
Arch's repository. It will be deployed soon on many systems when 
they'll be updated. As you may have seen from the latest comments in 
bug 72061, another Arch user has reported today encountering the same 
problem as myself.

Alexandre Demers

On Sun 30 Mar 2014 12:53:56 PM EDT, Alexandre Demers wrote:
> Oh boy... Maybe. I'll look at this option this week.
>
> Alexandre Demers
>
> On Sun 30 Mar 2014 08:31:28 AM EDT, Tejun Heo wrote:
>> On Sat, Mar 29, 2014 at 06:08:30PM -0400, Alexandre Demers wrote:
>>> That fixes the problem, I'm now running 3.14-rc8 with your patch
>>> applied.
>>
>> Just sent out the patch but I think we still need to find out what's
>> going on.  Is there any chance you can create a qemu image which shows
>> the same behavior?
>>
>> Thanks.
>>
