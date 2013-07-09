Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3GIM01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:26:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3GIM00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:26:26 -0400
Message-ID: <51DC016E.9070900@redhat.com>
Date: Tue, 09 Jul 2013 08:26:22 -0400
From: Cole Robinson <crobinso@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: qemu-devel@nongnu.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] sending SEGV to qemu crashes host kernel in Fedora
 19
References: <CAPM=9twiAK18Ny7QMMZA+DHFB=wQ2pxg8rDV+vj91TJjd_e2fg@mail.gmail.com> <CAPM=9tzT3EaZm=BRxxQe8+u-VtE8_F72-6X9ZJbLgnX7XMV7Vw@mail.gmail.com>
In-Reply-To: <CAPM=9tzT3EaZm=BRxxQe8+u-VtE8_F72-6X9ZJbLgnX7XMV7Vw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 09:11 PM, Dave Airlie wrote:
> On Tue, Jul 9, 2013 at 10:35 AM, Dave Airlie <airlied@gmail.com> wrote:
>> Hi,
>>
>> F19
>> kernel-3.9.8-300.fc19.x86_64
>> qemu-kvm-1.4.2-4.fc19.x86_64
>>
>> If I start a complete F19 install in the guest and send the qemu
>> process a SEGV signal, the host kernel starts giving me random kmalloc
>> errors soon after, if I send a normal kill signal things seem fine.
>>
>> CPU is Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz, on a HP 220z workstation.
>>
>> I initially blamed bad RAM but this reproduces everytime, and I
>> swapped DIMMs around
>>
>> I haven't tested with upstream kernel/qemu yet, but I wondered if
>> anyone else has seen this.
>>
>> I noticed this because some work I was doing was segfaulting my qemu
>> and then my machine would die a few mins later.
> 
> Of course now I read my fedora kernel emails and notice vhost_net does
> bad things,
> 
> disabling vhost_net seems to make it work fine, hopefully the next
> Fedora kernel will bring the magic fixes.
> 

That issue and another nasty crasher are being tracked here:

https://bugzilla.redhat.com/show_bug.cgi?id=980254

- Cole

