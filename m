Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaCMUAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:00:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42791 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbaCMT77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:59:59 -0400
Message-ID: <53220DEB.6030902@zytor.com>
Date: Thu, 13 Mar 2014 12:58:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Andi Kleen <ak@linux.intel.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>	<1394664680-17799-4-git-send-email-stefani@seibold.net>	<5320E689.7060607@zytor.com>	<CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com>	<5321D45C.7040504@zytor.com>	<CALCETrVy3oW=qvJWbGtKTZ=0dZLjHtmBphPDnP1N8nLmXc=+9A@mail.gmail.com>	<5321F418.1030304@zytor.com>	<5321F72E.7030109@zytor.com>	<CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com>	<CA+55aFyOp6V_tE-sXKVi+=6yVwHQb0sLWSNbk=N7KbhBrx9QhA@mail.gmail.com>	<CA+55aFyCSL==4Ff4JT3uFKN_28mz92ef1L67-4OUGqHZ8HXUhg@mail.gmail.com>	<CALCETrVa2XPc5JBDbDdH1ciavi2tuqwBf7picE4TVf69n_PcKw@mail.gmail.com>	<CA+55aFwDn3zA0gEn2r3nJVPWuv-pLYyrj4=8_gt1xFTd2g_Dwg@mail.gmail.com>	<8cf1b00c-ef93-4ad0-97f7-53888b50d160@email.android.com> <CA+55aFxWsm=P5h1o=BNrwkcy2ZadFsVxpegxJ0rskPVcmo_Ljw@mail.gmail.com>
In-Reply-To: <CA+55aFxWsm=P5h1o=BNrwkcy2ZadFsVxpegxJ0rskPVcmo_Ljw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 12:37 PM, Linus Torvalds wrote:
> There are big advantages to "minimal code" at fixed addresses. The
> vdso=native thing fills the page with 0xcc just to not give useful
> instructions (still on my phone, so that may be a bogus memory)
> 
> That said, I doubt we care just for OpenSUSE 9. Let it be slower.

Yes.

	-hpa


