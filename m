Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaCMVG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:06:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44093 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbaCMVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:06:27 -0400
Message-ID: <53221D78.7000606@zytor.com>
Date: Thu, 13 Mar 2014 14:04:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
References: <5321F418.1030304@zytor.com> <5321F72E.7030109@zytor.com> <CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com> <CA+55aFyOp6V_tE-sXKVi+=6yVwHQb0sLWSNbk=N7KbhBrx9QhA@mail.gmail.com> <CA+55aFyCSL==4Ff4JT3uFKN_28mz92ef1L67-4OUGqHZ8HXUhg@mail.gmail.com> <CALCETrVa2XPc5JBDbDdH1ciavi2tuqwBf7picE4TVf69n_PcKw@mail.gmail.com> <CA+55aFwDn3zA0gEn2r3nJVPWuv-pLYyrj4=8_gt1xFTd2g_Dwg@mail.gmail.com> <8cf1b00c-ef93-4ad0-97f7-53888b50d160@email.android.com> <CA+55aFxWsm=P5h1o=BNrwkcy2ZadFsVxpegxJ0rskPVcmo_Ljw@mail.gmail.com> <53220DEB.6030902@zytor.com> <20140313210010.GB3793@tassilo.jf.intel.com>
In-Reply-To: <20140313210010.GB3793@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 02:00 PM, Andi Kleen wrote:
> 
> At some point the majority of my nfsroot test image were OpenSUSE 9.
> It was the last opensuse system that booted fast without udev or initrd :-)
> 
> I have mostly retired them by now, but still occasional usage.
> 
> So that why i would prefer to not cripple it.
> 

It is already crippled in the sense that you can't boot without
CONFIG_COMPAT_VDSO... so in that sense nothing has really changed.

	-hpa


