Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaBOPEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 10:04:16 -0500
Received: from www84.your-server.de ([213.133.104.84]:43113 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaBOPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 10:04:12 -0500
Message-ID: <1392476701.17368.1.camel@wall-e.seibold.net>
Subject: Re: [PATCH v16 0/10] Add 32 bit VDSO time function support
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
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
Date: Sat, 15 Feb 2014 16:05:01 +0100
In-Reply-To: <CALCETrWhpmixwh4z6D1vBQVWvuNvg8-iTX9Vvi1J9-YMajrDdQ@mail.gmail.com>
References: <1392367964-32118-1-git-send-email-stefani@seibold.net>
	 <CALCETrWhpmixwh4z6D1vBQVWvuNvg8-iTX9Vvi1J9-YMajrDdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 14.02.2014, 14:40 -0800 schrieb Andy Lutomirski:
> On Fri, Feb 14, 2014 at 12:52 AM, Stefani Seibold <stefani@seibold.net> wrote:
> > This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> > and vdso_time() to the 32 bit VDSO.
> 
> Is there any chance you can shove this in a git tree somewhere for the
> next version (in addition to sending patches)?  I don't have magic
> scripts to make pulling these things in from gmail easy.
> 

Sorry, i don't think so, because it would be necessary to upload the
whole kernel tree to git-hub. That is not practical for me.

- Stefani


