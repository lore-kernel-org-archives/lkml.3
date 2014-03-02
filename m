Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaCBQcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 11:32:47 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:45336 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCBQcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 11:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140302104744.GB18257@gmail.com>
References: <1393752020-6740-1-git-send-email-stefani@seibold.net> <20140302104744.GB18257@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Mar 2014 08:32:24 -0800
Message-ID: <CALCETrWgtWt8EjQpx0DdDq076gcXfiWAw7NnO6z9Kp3Ongj2RA@mail.gmail.com>
Subject: Re: [PATCH v21 00/12] Add 32 bit VDSO time function support
To: Ingo Molnar <mingo@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
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

On Sun, Mar 2, 2014 at 2:47 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stefani Seibold <stefani@seibold.net> wrote:
>
>> This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
>> and vdso_time() to the 32 bit VDSO.
>
> What I'm missing from all the series is any trace of the significant
> review and debug work that Andy Lutomirski did for the series. Please
> add Acked-by or Reviewed-by tags to credit his contributions, as
> appropriate. (if Andy is fine with that.)
>

I'm okay w/ Reviewed-by, except for the patch for 32-bit vdso on
64-bit, which I haven't really reviewed (nor do I feel fully qualified
to review it -- it's a bit of a core change, and I'd prefer for
someone involved in that code to comment on it).

For the patches I wrote, "From" would be nice :)

OTOH, hpa may prefer incremental patches, now that this lives in tip.

--Andy
