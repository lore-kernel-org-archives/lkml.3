Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaCTQ4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:56:42 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:58800 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaCTQ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <532B104D.8050601@zytor.com>
References: <1395301511-5908-1-git-send-email-stefani@seibold.net>
 <alpine.DEB.2.02.1403201039400.18573@ionos.tec.linutronix.de>
 <1395315494.1127.3.camel@vger.seibold.net> <alpine.DEB.2.02.1403201328520.18573@ionos.tec.linutronix.de>
 <CALCETrVgC7yKsu0KM0=TfUuX9msn9ru_nG=Fv6Mz6PKDTnWGnQ@mail.gmail.com>
 <alpine.DEB.2.02.1403201614360.18573@ionos.tec.linutronix.de>
 <CALCETrWQbviwiQi2cJi=_kkjTPG8NpsYT4Sf0UB8SaDWN5rr7A@mail.gmail.com> <532B104D.8050601@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Mar 2014 09:56:18 -0700
Message-ID: <CALCETrWR-2DpSorAaQpru5u9igNXCqP66=43a+_bRs3F0q8KOA@mail.gmail.com>
Subject: Re: [PATCH] x86, vdso32: fix out of memory handling setup vDSO
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 8:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/20/2014 08:18 AM, Andy Lutomirski wrote:
>>
>> Not really.  I'll play with it a bit.
>>
>
> That would be really nice.
>

Holy cow the 32-bit vdso code is a mess.  I have a patch to clean up
this bit of it, and I'll send it out once I've tested it a bit.

--Andy

>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
