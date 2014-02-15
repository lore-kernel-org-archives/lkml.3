Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaBOCpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 21:45:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaBOCpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 21:45:49 -0500
Date: Fri, 14 Feb 2014 18:48:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andy Lutomirski <luto@amacapital.net>
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
Subject: Re: [PATCH v16 0/10] Add 32 bit VDSO time function support
Message-ID: <20140215024806.GB2542@kroah.com>
References: <1392367964-32118-1-git-send-email-stefani@seibold.net>
 <CALCETrWhpmixwh4z6D1vBQVWvuNvg8-iTX9Vvi1J9-YMajrDdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWhpmixwh4z6D1vBQVWvuNvg8-iTX9Vvi1J9-YMajrDdQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 02:40:12PM -0800, Andy Lutomirski wrote:
> On Fri, Feb 14, 2014 at 12:52 AM, Stefani Seibold <stefani@seibold.net> wrote:
> > This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> > and vdso_time() to the 32 bit VDSO.
> 
> Is there any chance you can shove this in a git tree somewhere for the
> next version (in addition to sending patches)?  I don't have magic
> scripts to make pulling these things in from gmail easy.

I'd recommend not using gmail for getting kernel patches, that's what
the imap interface is for :)
