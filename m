Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaCZBDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 21:03:55 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:49439 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaCZBDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 21:03:54 -0400
Message-ID: <53322777.3030703@gmail.com>
Date: Tue, 25 Mar 2014 21:03:51 -0400
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
References: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com> <20140314140804.GG12613@htj.dyndns.org> <CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com> <20140317201346.GE17373@mtj.dyndns.org> <5327AAA8.2080703@gmail.com>
In-Reply-To: <5327AAA8.2080703@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, I tried RC8 and I'm still getting the error. It start too fast to 
be able to read whatever it is saying, but here is what I can read:
...
cp: error writing /run/initramfs/new_root/...
cp: failed to extend ...
... (and so on)

It goes on like that for a long time.

Alexandre Demers

On Mon 17 Mar 2014 10:08:40 PM EDT, Alexandre Demers wrote:
> By the way, I tried to get the error message, but my display had gone
> in standby mode before it completed and it wouldn't wake up. I'll have
> to test with an earlier 3.14 kernel (rc1 or rc2), when it was
> answering to my wake up signal. Even though my display doesn't wake up
> with rc6, it is still running since I can see some activities on my
> disk from time to time.
>
> I'll be back with more info ASAP.
>
> Alexandre Demers
>
> On Mon 17 Mar 2014 04:13:46 PM EDT, Tejun Heo wrote:
>> Hello,
>>
>> On Fri, Mar 14, 2014 at 11:48:10AM -0400, Alexandre Demers wrote:
>>> Since it takes a while before the system begins to display errors,
>>> I'll have to test it and report it later today when I'll get back from
>>> work.
>>
>> Any update?
>>
>>> Now, about the userland part, this seems a broad question... I'm using
>>> Arch Linux 64bit (updated mostly on a daily basis). But I suspect you
>>> are expecting a narrower information. Is there anything in particular
>>> you want to know?
>>
>> I was just wondering whether you were running something really exotic.
>> Doesn't seem that way.  Weird that other people aren't hitting this
>> issue.  Hmm...
>>
>> Thanks.
>>
