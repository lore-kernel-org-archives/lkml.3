Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935278Ab3BOBOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 20:14:08 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:60216 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3BOBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 20:14:06 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302142334120.22263@ionos>
References: <6003615.pRQnIgKCSn@dabox> <3970144.HqS49ZSYWh@dabox>
 <alpine.LFD.2.02.1302131828050.22263@ionos> <16398840.IK9i4U2q2d@dabox> <alpine.LFD.2.02.1302142334120.22263@ionos>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 14 Feb 2013 20:13:34 -0500
X-Google-Sender-Auth: EfXgEFYGpHXEaOrBFR52DI51v1g
Message-ID: <CAP=VYLo2zxJWy3s6AmZc+Hh6wXh67HMp+mM0nEkN6M_OpKJSug@mail.gmail.com>
Subject: Re: [PATCH] 3.4.28-rt40 tglx fix imx.c spinlock
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Sander <tim@krieglstein.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding dave jones to CC]

On Thu, Feb 14, 2013 at 5:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 14 Feb 2013, Tim Sander wrote:
>> > That's true, but w/o seing the OOM output I can't tell what's
>> > exhausting the memory.
>> When fuzzing the serial port one probably should switch of sysreq. It seems
>> as if there is a break send somehow and then it selects the OOM option.
>> So when switching of MAGIC_SYSRQ the OOMs are gone. So its a non issue.
>
> Amazing that you get the break+oom combo out of that fuzzer!

Doing a basic "git whatchanged" and searching for "trinity" is rather
impressive, regardless of the kernel version and/or where "rogue states"
may currently be at with their "program"....   Kudos to davej for that.

P.
--
