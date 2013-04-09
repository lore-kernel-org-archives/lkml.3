Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935581Ab3DIOE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:04:56 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:50129 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761269Ab3DIOEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:04:55 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <31778276.CDMUtaAAnc@vostro.rjw.lan>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<31778276.CDMUtaAAnc@vostro.rjw.lan>
Date: Tue, 9 Apr 2013 16:04:53 +0200
Message-ID: <CA+icZUXXHb9vmcNuFmYha34SV7xch2S8OcgZ+cLVVnNebs5pNQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 4:03 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, April 09, 2013 02:47:39 PM Sedat Dilek wrote:
>> On Tue, Apr 9, 2013 at 11:30 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi all,
>> >
>> > Changes since 20130408:
>> >
>> > The vfs tree still had its build failure so I used the version from
>> > next-20130405.
>> >
>> > The wireless-next tree lost its build failure.
>> >
>> > The mfd tree still had its build failure so I used the version from
>> > next-20130405.
>> >
>> > The ftrace tree gained a conflict against Linus' tree.
>> >
>> > The arm-soc tree gained conflicts against the omap_dss2 and gpio-lw trees.
>> >
>> > ----------------------------------------------------------------------------
>> >
>>
>> On reboot I see hanging cpufreq with the help of kdb/kgdb?
>> See screenshot.
>>
>> I have also a screenshot with next-20130326, so this issue seems not to be new.
>
> This is during CPU offline.  Does it only happen on reboot?  What about trying
> to offline/online CPUs from sysfs?
>

I have seen it on reboots.
How to online/offline from sysfs?

- Sedat -

> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
