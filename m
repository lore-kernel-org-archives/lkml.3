Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaGFFRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 01:17:06 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:58434 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaGFFRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 01:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVhxh2pcs0Z3j-0=9-2csojtD7BBKs1oxZgJANe-LsT+aw@mail.gmail.com>
References: <20140704164251.7dc67e07@canb.auug.org.au>
	<CAK5sBcGq54sOSzJKXrEbhAUTZZh=+9NuVh294Qxn0dQvbh-G8w@mail.gmail.com>
	<20140705011058.198ae810@canb.auug.org.au>
	<20140705004846.GA11659@fieldses.org>
	<CAK5sBcF72eYPL6=h9JttsWa6MF4cafJb-WO3+JOAh5X4-knKqw@mail.gmail.com>
	<CAPDOMVhxh2pcs0Z3j-0=9-2csojtD7BBKs1oxZgJANe-LsT+aw@mail.gmail.com>
Date: Sun, 6 Jul 2014 01:17:02 -0400
Message-ID: <CAPDOMVheB0OWkGKVNqWW=k1mm5MQmRR-Vc2pZJYY6SSszVPqQA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 4
From: Nick Krause <xerofoify@gmail.com>
To: Sachin Kamat <spk.linux@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are my test logs for arm. Most of the failures from these builds
not having default configures or  make one by one errors. Below are
my typed results.
Results
iop13xx_defconfig - Successes in my tests
mackerel_defconfig - Fails in my tests
nuc910_defconfig - Fails in my tests
nuc950_defconfig -Fails in my tests
nuc960_defconfig - Fails in my tests
s5p64x0_defconfig - Fails in my tests
s5p64x0_defconfig - Fails in my tests
arm-randconfig -Fails in my tests
BF561-ACVILON_defconfig -Fails in my tests
BlackStamp_defconfig - Fails in my tests
TCM-BF518_defconfig - Fails in my tests

Cheers Nick

On Sun, Jul 6, 2014 at 12:54 AM, Nick Krause <xerofoify@gmail.com> wrote:
> Hey guys ,
> I checking Sachin Karmat's tests and fixing compile issues with
> patches if need be. In my next email I am going to give a up to date
> log of still failing builds for arm.
> Cheers Nick
>
> On Sat, Jul 5, 2014 at 10:57 AM, Sachin Kamat <spk.linux@gmail.com> wrote:
>> On Sat, Jul 5, 2014 at 6:18 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
>>> On Sat, Jul 05, 2014 at 01:10:58AM +1000, Stephen Rothwell wrote:
>>>> Hi Sachin,
>>>>
>>>> On Fri, 4 Jul 2014 14:12:11 +0530 Sachin Kamat <spk.linux@gmail.com> wrote:
>>>> >
>>>> > Was bisecting a kernel crash on Arndale octa board (Exynos5420). It
>>>> > points to a merge
>>>> > commit:
>>>> > 40556a4c485d12d324f1ea196cc30f590e564237 is the first bad commit
>>>> > ("Merge remote-tracking branch 'nfsd/nfsd-next'").
>>>> >
>>>> > How do I proceed with this?
>>>>
>>>> I guess we get the owner of the tree (possibly) in question involved
>>>> (cc'd).
>>>
>>> Looking at the total diffstat for that branch, it's almost all contained
>>> in fs/nfsd with a little in include/linux/sunrpc/ and net/sunrpc.  So
>>> it's extremely unlikely that it would be causing a problem unless you're
>>> actually testing nfsd.
>>
>> I found it surprising too as I do not use nfsd. I will try out the things
>> suggested by Stephen and update.
>>
>> --
>> Regards,
>> Sachin.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
