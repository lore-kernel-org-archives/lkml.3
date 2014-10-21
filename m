Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaJUEjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:39:12 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64576 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaJUEjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:39:10 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXHR+ieAxxsPAEO-V2x70VVfp3TDLTJ7jNX5g9tvwqwgQ@mail.gmail.com>
References: <cover.1411494540.git.luto@amacapital.net> <54458199.1000607@zytor.com>
 <CALCETrXcTwOQLQX0Tx8XgDPaWit9P5ut1p8mDehAcAah9V17wQ@mail.gmail.com>
 <544586AD.30407@zytor.com> <CALCETrXHR+ieAxxsPAEO-V2x70VVfp3TDLTJ7jNX5g9tvwqwgQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 21:38:48 -0700
Message-ID: <CALCETrVTQy8=m1PnYYbbX-quJFYw5qDeAXvkuKdLo8bqCVq+vQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] x86: Disentangle the vdso and clean it up
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 3:41 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Oct 20, 2014 at 3:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 10/20/2014 02:57 PM, Andy Lutomirski wrote:
>>>
>>> Should I send a replacement for patch 8 or should I let you merge 1-7
>>> and fold this into the followup series?
>>>
>>
>> Please send a replacement.
>
> Sending in a sec.
>
> Also, this is really weird.  Unless I'm completely nuts, lsl is faster
> in KVM than it is on bare metal.  This makes me wonder whether
> something's suboptimal about the way that the GDT is set up.  sgdt is
> faster, too.  This is Sandy Bridge E, one socket.  The difference is
> big enough that tracking it down might be a significant win on context
> switches.  Any hints?
>

This may just be a weird cpufreq artifact.  I need to improve my test tools :/

--Andy
