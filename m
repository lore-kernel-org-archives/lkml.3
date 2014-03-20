Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbaCTRIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:08:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbaCTRIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:08:00 -0400
Message-ID: <532B2022.90907@zytor.com>
Date: Thu, 20 Mar 2014 10:06:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH] x86, vdso32: fix out of memory handling setup vDSO
References: <1395301511-5908-1-git-send-email-stefani@seibold.net> <alpine.DEB.2.02.1403201039400.18573@ionos.tec.linutronix.de> <1395315494.1127.3.camel@vger.seibold.net> <alpine.DEB.2.02.1403201328520.18573@ionos.tec.linutronix.de> <CALCETrVgC7yKsu0KM0=TfUuX9msn9ru_nG=Fv6Mz6PKDTnWGnQ@mail.gmail.com> <alpine.DEB.2.02.1403201614360.18573@ionos.tec.linutronix.de> <CALCETrWQbviwiQi2cJi=_kkjTPG8NpsYT4Sf0UB8SaDWN5rr7A@mail.gmail.com> <532B104D.8050601@zytor.com> <CALCETrWR-2DpSorAaQpru5u9igNXCqP66=43a+_bRs3F0q8KOA@mail.gmail.com>
In-Reply-To: <CALCETrWR-2DpSorAaQpru5u9igNXCqP66=43a+_bRs3F0q8KOA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 09:56 AM, Andy Lutomirski wrote:
> 
> Holy cow the 32-bit vdso code is a mess.  I have a patch to clean up
> this bit of it, and I'll send it out once I've tested it a bit.
> 

Thanks.

	-hpa


