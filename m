Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaG3UO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:14:28 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48911 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaG3UO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:14:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140730153315.GA29233@localhost>
References: <20140730142923.GR16537@localhost> <CALCETrW2Pygpt8sFWuXtijtcZGxrHcLa8hSFk7ooKvPiU9-M3w@mail.gmail.com>
 <20140730153315.GA29233@localhost>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 30 Jul 2014 13:14:06 -0700
Message-ID: <CALCETrXPesCD089zp6JHwaJc=JJb2FBRoFBCUj8DyCr2FjLCNA@mail.gmail.com>
Subject: Re: [x86_64,vsyscall] Kernel panic - not syncing: Attempted to kill
 init! exitcode=0x0000000b
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 8:33 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Wed, Jul 30, 2014 at 07:58:13AM -0700, Andy Lutomirski wrote:
>> On Wed, Jul 30, 2014 at 7:29 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> > Greetings,
>> >
>> > 0day kernel testing robot got the below dmesg and the first bad commit is
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/vsyscall
>> > commit 442aba0c6131f0c41dfc5edb6bfb88335556523f
>> > Author:     Andy Lutomirski <luto@amacapital.net>
>> > AuthorDate: Mon Jun 16 18:50:12 2014 -0700
>> > Commit:     Andy Lutomirski <luto@amacapital.net>
>> > CommitDate: Mon Jun 30 14:32:44 2014 -0700
>>
>> Was this a merge?
>
> It's not a merge commit.

Hmm.  It looks like that commit is from a version of x86/vsyscall
that's rather out-of-date.  Is it possible that the script is testing
an old version of the tree?  I haven't touched it in almost a week, I
think.

>
>> Is there an easy way to see exactly what was tested?
>
> This script may reproduce the error. Note that it's not 100% reproducible.

It fails with:

[    1.214573] VFS: Cannot open root device "ram0" or
unknown-block(0,0): error -6
[    1.216567] Please append a correct "root=" boot option; here are
the available partitions:
[    1.218692] 0b00         1048575 sr0  driver: sr

--Andy
