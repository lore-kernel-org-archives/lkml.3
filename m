Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaCMVBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:01:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:48683 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbaCMVBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:01:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,649,1389772800"; 
   d="scan'208";a="499451358"
Date: Thu, 13 Mar 2014 14:00:10 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20140313210010.GB3793@tassilo.jf.intel.com>
References: <5321F418.1030304@zytor.com>
 <5321F72E.7030109@zytor.com>
 <CALCETrXjJeXqJj3muJhfNeiQ7Te+8WSow+LtjKPM9dySfDtbaA@mail.gmail.com>
 <CA+55aFyOp6V_tE-sXKVi+=6yVwHQb0sLWSNbk=N7KbhBrx9QhA@mail.gmail.com>
 <CA+55aFyCSL==4Ff4JT3uFKN_28mz92ef1L67-4OUGqHZ8HXUhg@mail.gmail.com>
 <CALCETrVa2XPc5JBDbDdH1ciavi2tuqwBf7picE4TVf69n_PcKw@mail.gmail.com>
 <CA+55aFwDn3zA0gEn2r3nJVPWuv-pLYyrj4=8_gt1xFTd2g_Dwg@mail.gmail.com>
 <8cf1b00c-ef93-4ad0-97f7-53888b50d160@email.android.com>
 <CA+55aFxWsm=P5h1o=BNrwkcy2ZadFsVxpegxJ0rskPVcmo_Ljw@mail.gmail.com>
 <53220DEB.6030902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53220DEB.6030902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:58:35PM -0700, H. Peter Anvin wrote:
> On 03/13/2014 12:37 PM, Linus Torvalds wrote:
> > There are big advantages to "minimal code" at fixed addresses. The
> > vdso=native thing fills the page with 0xcc just to not give useful
> > instructions (still on my phone, so that may be a bogus memory)
> > 
> > That said, I doubt we care just for OpenSUSE 9. Let it be slower.
> 
> Yes.

At some point the majority of my nfsroot test image were OpenSUSE 9.
It was the last opensuse system that booted fast without udev or initrd :-)

I have mostly retired them by now, but still occasional usage.

So that why i would prefer to not cripple it.

-Andi
