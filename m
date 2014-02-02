Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaBBP10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 10:27:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44890 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaBBP1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 10:27:25 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1391340025.10379.1.camel@wall-e.seibold.net>
References: <1391268756-10766-1-git-send-email-stefani@seibold.net> <1391268756-10766-4-git-send-email-stefani@seibold.net> <CALCETrVp+aTm_mT4bg6kcaX3QOnqyjVdfM9vdhHZPsKG276X0A@mail.gmail.com> <52ED90A3.9080802@zytor.com> <1391340025.10379.1.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 3/4] Add 32 bit VDSO time support for 32 bit kernel
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 02 Feb 2014 07:25:45 -0800
To: Stefani Seibold <stefani@seibold.net>
CC: Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Message-ID: <ba6a0d87-e6aa-4cb6-bf3c-c14aa3ea9379@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I did not know/realize, and unfortunately  "he" is the grammatical default in English, although the singular they is fortunately making a comeback.

I stand corrected, through.  Please acer my apologies.

  -hpa

On February 2, 2014 3:20:25 AM PST, Stefani Seibold <stefani@seibold.net> wrote:
>
>> >>
>> >> -#define VDSO_HIGH_BASE         0xffffe000U /* CONFIG_COMPAT_VDSO
>address */
>> >> +#define VDSO_HIGH_BASE         0xffffc000U /* CONFIG_COMPAT_VDSO
>address */
>> > 
>> > This is odd.  Can you explain it?
>> > 
>> 
>> He needs 3 pages instead of 1 after his changes.
>> 
>
>Not every kernel hackers a male. By definition i am femal, so please
>replace he and his with she and her.
>
>- Stefani

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
