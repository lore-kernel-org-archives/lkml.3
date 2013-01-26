Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3AZMF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:05:57 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:47824 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3AZMFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:05:55 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
References: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
Date: Sat, 26 Jan 2013 13:05:53 +0100
Message-ID: <CA+icZUWqdPz5xFRYy6UMjN9QQNq61oJ=fP_KGOt5SH3o0DH62Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 25 (BROKEN suspend)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 12:10 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Jan 25, 2013 at 6:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20130124:
>>
>> New trees: ipsec and ipsec-next
>>
>> The powerpc tree still had a build failure.
>>
>> The sound-asoc tree still had its build failure so I used the version from
>> next-20130122.
>>
>> The akpm tree lost its build failure and several patches that turned up
>> elsewhere.
>>
>> ----------------------------------------------------------------------------
>>
>
> Unfortunately, on suspend or running the pm_test/freezer leads here to
> a frozen machine - hard reset.
>
> I see 4-5 pages of call-traces but dunno how to log them in such a f-u-ed state.
> Any hints welcome!
>
> As I saw catched with my left eye on one call-trace sth. with...
>
>       kernel/watchdog.c (line #245, watchdog_overflow_callback)
>
> ... I tried to revert the last two commits from Sascha (see -3 patch,
> but no success.
>
> The same with reverting all cpu-freq changes since v3.8-rc4 (see -4
> patch) after seeing some suspicious lines on the screen.
>
> Can someone confirm that suspend is BROKEN for him/her before doing
> eventually a bisect?
>
> Thanks!
>
> Regards,
> - Sedat -
>
> [1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=kernel/watchdog.c;hb=refs/tags/next-20130125#l245

Just FYI:

Linux-Next (next-20130124) is also BROKEN on suspend here.

Latest GOOD is next-20130123... next-20130121 was also GOOD (I had
tested some days ago).

- Sedat -
