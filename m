Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaBBQqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:46:36 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57301 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaBBQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:46:35 -0500
MIME-Version: 1.0
In-Reply-To: <1391340435-5130-8-git-send-email-stefani@seibold.net>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net> <1391340435-5130-8-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Feb 2014 08:46:14 -0800
Message-ID: <CALCETrXNVoJBUncHbWWuQ7LAf2ZoWOY8uJBeg_VD1+MmwJ07Rg@mail.gmail.com>
Subject: Re: [PATCH 7/8] Add 32 bit VDSO time support for 32 bit kernel
To: Stefani Seibold <stefani@seibold.net>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 2, 2014 at 3:27 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This patch add the time support for 32 bit a VDSO to a 32 bit kernel.

[...]

Can you address the review comments from last time around?  For
example, this still seems to have redundant vvar and hpet mappings, it
doesn't use the VVAR macro, it moves the 32-bit compat vDSO, etc.

Also, the usual convention is to use [PATCH v2 3/8], etc, as subjects,
to keep separate versions separate.

--Andy
