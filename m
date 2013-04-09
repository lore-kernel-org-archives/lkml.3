Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937165Ab3DIQIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:08:50 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58477 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935855Ab3DIQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:08:48 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKohpok+9dRaENjBfnN9gZF3zvFU9v19xV_eFfcM3Pj6Cv=S2w@mail.gmail.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<31778276.CDMUtaAAnc@vostro.rjw.lan>
	<CA+icZUXXHb9vmcNuFmYha34SV7xch2S8OcgZ+cLVVnNebs5pNQ@mail.gmail.com>
	<CAKohpok+9dRaENjBfnN9gZF3zvFU9v19xV_eFfcM3Pj6Cv=S2w@mail.gmail.com>
Date: Tue, 9 Apr 2013 18:08:46 +0200
Message-ID: <CA+icZUWH5Ni9koj4V8Ws8jJ7smwmU7JuUWBFh=aiCqkrCpqB5A@mail.gmail.com>
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

With x=3 the system gets in an unuseable state.

     root# echo 0 > /sys/devices/system/cpu/cpu3/online

I could not write my reply and had to do a hard/cold reboot.
The dmesg log I saw looked similiar to my digicam-shot.

- Sedat -
