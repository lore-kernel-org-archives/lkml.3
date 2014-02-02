Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaBBLTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 06:19:43 -0500
Received: from www84.your-server.de ([213.133.104.84]:37134 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaBBLTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 06:19:41 -0500
Message-ID: <1391340025.10379.1.camel@wall-e.seibold.net>
Subject: Re: [PATCH 3/4] Add 32 bit VDSO time support for 32 bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
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
Date: Sun, 02 Feb 2014 12:20:25 +0100
In-Reply-To: <52ED90A3.9080802@zytor.com>
References: <1391268756-10766-1-git-send-email-stefani@seibold.net>
	 <1391268756-10766-4-git-send-email-stefani@seibold.net>
	 <CALCETrVp+aTm_mT4bg6kcaX3QOnqyjVdfM9vdhHZPsKG276X0A@mail.gmail.com>
	 <52ED90A3.9080802@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >>
> >> -#define VDSO_HIGH_BASE         0xffffe000U /* CONFIG_COMPAT_VDSO address */
> >> +#define VDSO_HIGH_BASE         0xffffc000U /* CONFIG_COMPAT_VDSO address */
> > 
> > This is odd.  Can you explain it?
> > 
> 
> He needs 3 pages instead of 1 after his changes.
> 

Not every kernel hackers a male. By definition i am femal, so please
replace he and his with she and her.

- Stefani


