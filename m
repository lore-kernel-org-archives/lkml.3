Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaCFS2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:28:21 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:59654 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaCFS2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:28:19 -0500
MIME-Version: 1.0
In-Reply-To: <CA+MoWDrTNtAHKsiBHz=W4=eJRO=m9EK_HZ7zLxb=4fg5riUQeg@mail.gmail.com>
References: <CA+MoWDrTNtAHKsiBHz=W4=eJRO=m9EK_HZ7zLxb=4fg5riUQeg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Mar 2014 11:27:58 -0700
Message-ID: <CAErSpo4wdYDgTUTBDLimbviLh54C9ELXKfQ2y5qeUR1FKN8fpw@mail.gmail.com>
Subject: Re: My Kernel bug is celebrating 2 years. Can you help me fix it?
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stoney Wang <song-bo.wang@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Stoney, Yinghai, Suresh, Joerg, Jiang, Pavel, Rafael, linux-pm]

Let's add some folks who know about x2apic and VT-d.  It's hard for
people to magically pick stuff out of the LKML firehose :)

On Tue, Mar 4, 2014 at 2:26 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> I have reported a bug more than two years ago and it is still
> affecting me. The bug report gives some information:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=787299
>
> I have tried basic debug instructions from:
> https://www.kernel.org/doc/Documentation/power/basic-pm-debugging.txt
>
> And everything works as expected when:
> # echo freeze > /sys/power/state
> # echo disk > /sys/power/state
>
> I have asked for help for fixing it:
> https://lkml.org/lkml/2013/11/1/186
>
> But I don't have a serial port. How can I debug this issue without a
> "real" serial port? Or what else can I try? How can I explore the hint
> about the problem only happening with VT-d enabled in BIOS? How can I
> explore the hint about the problem not happening if the option
> nox2apic is passed to the Kernel?
>
> Thank you,
>
> Peter
>
> P.S Yes, it works on Windows.
>
> --
> Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
