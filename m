Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaBMGYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 01:24:09 -0500
Received: from www84.your-server.de ([213.133.104.84]:43701 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaBMGYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 01:24:08 -0500
Message-ID: <1392272645.1030.1.camel@wall-e.seibold.net>
Subject: Re: [PATCH v15 10/10] do conditional fixmap of VVAR and HPET page
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
Date: Thu, 13 Feb 2014 07:24:05 +0100
In-Reply-To: <CALCETrUo_Um3LiEMfeYwPTOZf=ZGuRtzLrr8_pvd+STVMwoYJA@mail.gmail.com>
References: <1392237658-6614-1-git-send-email-stefani@seibold.net>
	 <CALCETrUo_Um3LiEMfeYwPTOZf=ZGuRtzLrr8_pvd+STVMwoYJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 12.02.2014, 12:57 -0800 schrieb Andy Lutomirski:
> On Wed, Feb 12, 2014 at 12:40 PM,  <stefani@seibold.net> wrote:
> > From: Stefani Seibold <Stefani Seibold stefani@seibold.net>
> >
> > This patch adds conditional fixmap of the VVAR and HPET pages for a 32
> > bit kernel
> >
> > Signed-off-by: Stefani Seibold <Stefani Seibold stefani@seibold.net>
> 
> Looks good to me.
> 

Did this mean that i can add an acked-by to all patches?

> (Your git configuration is broken, though -- your signed-off-by line
> and from line are broken.)
> 

Oops... Still fixed.

- Stefani


