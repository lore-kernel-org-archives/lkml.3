Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaJQXw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 19:52:59 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:40968 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaJQXw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 19:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <20141017234445.GA28891@saruman>
References: <CAH2r5mvBOJHLbRXHMt50E97_1E2Q8F_=PH9=u6N3yuuqSQVmDg@mail.gmail.com>
 <20141017234445.GA28891@saruman>
From: Steve French <smfrench@gmail.com>
Date: Fri, 17 Oct 2014 18:52:37 -0500
Message-ID: <CAH2r5mtsh9KsVYJJWebJffvdQxOVTzM4cNM30q8hYOG=Bwj8eA@mail.gmail.com>
Subject: Re: current mainline doesn't boot
To: balbi@ti.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is vmware guest

sfrench@ubuntu:~/xfstests$ cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 70
model name    : Intel(R) Core(TM) i7-4750HQ CPU @ 2.00GHz

(and using 64 bit kernel build) ...

I don't have the Ubuntu config for their mainline kernel test builds
any more (deleted the kernel since it didn't work) but they post their
.config diffs at
http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/current/

I could not get to a console so assumed it died in kernel as x was
coming up.  I will have to reinstall current mainline to see if I can
hook up a serial console (I had maximum kernel boot verbose in the
grub.cfg but nothing interesting before the black screen)

On Fri, Oct 17, 2014 at 6:44 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Oct 17, 2014 at 05:44:02PM -0500, Steve French wrote:
>> Anyone know a workaround for the problem booting current mainline?
>> 3.17 works fine for me, but recent mainline since 3.17 goes to a black
>> screen near the end of boot as X is about to start.
>>
>> I also tried the Ubuntu build of the day (which also is based on
>> current mainline but with the Ubuntu config just in case it was some
>> driver issue) which fails the same way.
>
> you need to provide more information, here are a few queries which might
> help:
>
> 1. which architecture ?
> 2. Can you get a serial console to get some dmesg output ?
> 3. after screen is black, can you ctrl + alt + F1 and get a console ?
> 4. where's you .config ?
>
> --
> balbi



-- 
Thanks,

Steve
