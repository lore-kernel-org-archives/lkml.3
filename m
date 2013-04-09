Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937107Ab3DIO7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:59:12 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42005 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937057Ab3DIO7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <31778276.CDMUtaAAnc@vostro.rjw.lan>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<31778276.CDMUtaAAnc@vostro.rjw.lan>
Date: Tue, 9 Apr 2013 20:29:08 +0530
Message-ID: <CAKohpokFEGvqgBbUbuRp-HBBx3-3A+h96wbAApGdVPH3eMVOxg@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sedat.dilek@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 19:33, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, April 09, 2013 02:47:39 PM Sedat Dilek wrote:
>> On reboot I see hanging cpufreq with the help of kdb/kgdb?
>> See screenshot.
>>
>> I have also a screenshot with next-20130326, so this issue seems not to be new.
>
> This is during CPU offline.  Does it only happen on reboot?  What about trying
> to offline/online CPUs from sysfs?

Sorry Sedat but i can't find your original mail with attachments/logs.
Can you please send them to me and others again?
