Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaHaSek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:34:40 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54774 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaHaSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <6798670.9zbxUzsGyC@wuerfel>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
	<1409350479-19108-4-git-send-email-abrestic@chromium.org>
	<6798670.9zbxUzsGyC@wuerfel>
Date: Sun, 31 Aug 2014 11:34:36 -0700
X-Google-Sender-Auth: eXjALQgChIQgmisWYfKJwQ2G46k
Message-ID: <CAL1qeaE1jKLM0kK95efvcaeQwS4qjAR9-77Maa2q8aTJ4TC3jw@mail.gmail.com>
Subject: Re: [PATCH 03/12] of: Add binding document for MIPS GIC
From: Andrew Bresticker <abrestic@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 12:53 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 29 August 2014 15:14:30 Andrew Bresticker wrote:
>> The Global Interrupt Controller (GIC) present on certain MIPS systems
>> can be used to route external interrupts to individual VPEs and CPU
>> interrupt vectors.  It also supports a timer and software-generated
>> interrupts.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>  Documentation/devicetree/bindings/mips/gic.txt | 50 ++++++++++++++++++++++++++
>>
>
> This may be a stupid question, but is this related to the ARM GIC
> in any way or does it just share the name?

There's no relation.  Note that it's also "Global Interrupt
Controller" vs. "Generic Interrupt Controller".

> In either case the binding belongs into
> Documentation/devicetree/bindings/interrupt-controller/.

Will do.
