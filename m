Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaB0MOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:14:51 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:48376 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaB0MOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:14:48 -0500
Date: Thu, 27 Feb 2014 13:14:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: Final: Add 32 bit VDSO time function support
Message-ID: <20140227121444.GD9712@gmail.com>
References: <1393443298.1917.5.camel@wall-e.seibold.net>
 <20140226204524.GA1598@kroah.com>
 <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> On Wed, Feb 26, 2014 at 12:45 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Feb 26, 2014 at 08:34:58PM +0100, Stefani Seibold wrote:
> >> Hi,
> >>
> >> i still wait for ACK's for the  32 bit VDSO time function support. Whats
> >> the next step? Is there a way to apply it to the linux-git or linux-next
> >> in near future?
> >
> > I thought this was already in the tip tree.  Didn't the emails saying
> > this happened come by a few days ago?  Or was it pulled from there for
> > some reason?
> 
> It is in tip. [...]

It's excluded from tip:master right now due to testing failures. So 
it's neither in tip:master nor propagated towards linux-next.

Thanks,

	Ingo
