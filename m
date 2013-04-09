Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935564Ab3DIO70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:59:26 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45781 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765447Ab3DIO7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:59:22 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKohpok+9dRaENjBfnN9gZF3zvFU9v19xV_eFfcM3Pj6Cv=S2w@mail.gmail.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<31778276.CDMUtaAAnc@vostro.rjw.lan>
	<CA+icZUXXHb9vmcNuFmYha34SV7xch2S8OcgZ+cLVVnNebs5pNQ@mail.gmail.com>
	<CAKohpok+9dRaENjBfnN9gZF3zvFU9v19xV_eFfcM3Pj6Cv=S2w@mail.gmail.com>
Date: Tue, 9 Apr 2013 16:59:20 +0200
Message-ID: <CA+icZUV219yQ2Bw=81C8e_cfNERjCENNOvokehQ=bzc66-+L2w@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 4:56 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 9 April 2013 19:34, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> I have seen it on reboots.
>> How to online/offline from sysfs?
>
> offline a cpu "x" with:
>
> echo 0 > /sys/devices/system/cpu/cpux/online
>
> and online with echo 1 > to same location.

Eh, yeah I re-remember it now :-).
I will try with next-20130328 which boots fine here and hope the
hanging on reboot and in running system is OK.

next-20130409 is broken due to vfs-next issues (see Linux-Next ML).
Will try that first...

- Sedat -
