Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaBZUzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:55:12 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:44881 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaBZUzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:55:10 -0500
MIME-Version: 1.0
In-Reply-To: <20140226204524.GA1598@kroah.com>
References: <1393443298.1917.5.camel@wall-e.seibold.net> <20140226204524.GA1598@kroah.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Feb 2014 12:54:49 -0800
Message-ID: <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com>
Subject: Re: Final: Add 32 bit VDSO time function support
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 12:45 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Feb 26, 2014 at 08:34:58PM +0100, Stefani Seibold wrote:
>> Hi,
>>
>> i still wait for ACK's for the  32 bit VDSO time function support. Whats
>> the next step? Is there a way to apply it to the linux-git or linux-next
>> in near future?
>
> I thought this was already in the tip tree.  Didn't the emails saying
> this happened come by a few days ago?  Or was it pulled from there for
> some reason?

It is in tip.  I think that hpa wants people to test it before it goes
to Linus, and I certainly want to convince myself that there's no
performance regression.

--Andy

>
> thanks,
>
> greg k-h



-- 
Andy Lutomirski
AMA Capital Management, LLC
