Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbbAFTwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:52:04 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36914 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbbAFTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:51:47 -0500
MIME-Version: 1.0
In-Reply-To: <20150106191649.GU2915@two.firstfloor.org>
References: <87mw5x0xjz.fsf@tassilo.jf.intel.com> <54AAFFA3.6000901@linux.intel.com>
 <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
 <20150106040428.GR2915@two.firstfloor.org> <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com>
 <54AC1FFB.7030504@linux.intel.com> <CALCETrVJyBR7NoZvC=A4htRtm-fLe5NUEGUdvJRL28adU4MhUg@mail.gmail.com>
 <54AC29B1.70004@linux.intel.com> <CALCETrUE+kZeC+vx1OnpYsuL-b0u3fFJe3QfjeZQ=hCiQRPrHg@mail.gmail.com>
 <54AC2F62.40708@linux.intel.com> <20150106191649.GU2915@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 Jan 2015 11:51:26 -0800
Message-ID: <CALCETrUNpi1Gc-Qpmu1bJ0BVcSH2xquaY_X+YYhLjbPaQcf0_w@mail.gmail.com>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API to arch_prctl
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        ilya.enkovich@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 11:16 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Tue, Jan 06, 2015 at 10:54:26AM -0800, Dave Hansen wrote:
>> On 01/06/2015 10:41 AM, Andy Lutomirski wrote:
>> > The runtime seems to be here:
>> >
>> > https://software.intel.com/protected-download/267266/144917
>> >
>> > but I'm not going to accept the EULA.
>>
>> That is not the code I'm talking about here.
>
> The MPX run time patch is here (may not be the latest version)
>
> https://gcc.gnu.org/ml/gcc-patches/2014-11/msg01026.html
>

Ah, I see.

Given that it doesn't seen to have been committed yet, I'm not too
worried about compatibility.  And "prctl (43)" doesn't actually seem a
whole lot better than "syscall(SYS_arch_prctl, ARCH_ENABLE_MPX, 0)"
(preprocessor macros ftw!).  But I don't feel that strongly about this
point.

--Andy
