Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaB0FRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:17:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49782 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaB0FRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:17:14 -0500
Message-ID: <530EC7F8.2040503@zytor.com>
Date: Wed, 26 Feb 2014 21:07:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: Final: Add 32 bit VDSO time function support
References: <1393443298.1917.5.camel@wall-e.seibold.net> <20140226204524.GA1598@kroah.com> <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com>
In-Reply-To: <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 12:54 PM, Andy Lutomirski wrote:
> On Wed, Feb 26, 2014 at 12:45 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Wed, Feb 26, 2014 at 08:34:58PM +0100, Stefani Seibold wrote:
>>> Hi,
>>>
>>> i still wait for ACK's for the  32 bit VDSO time function support. Whats
>>> the next step? Is there a way to apply it to the linux-git or linux-next
>>> in near future?
>>
>> I thought this was already in the tip tree.  Didn't the emails saying
>> this happened come by a few days ago?  Or was it pulled from there for
>> some reason?
> 
> It is in tip.  I think that hpa wants people to test it before it goes
> to Linus, and I certainly want to convince myself that there's no
> performance regression.
> 

Absolutely.  Your help is *greatly* appreciated.

	-hpa


