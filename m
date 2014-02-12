Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaBLU57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:57:59 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:50756 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbaBLU5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:57:44 -0500
MIME-Version: 1.0
In-Reply-To: <1392237658-6614-1-git-send-email-stefani@seibold.net>
References: <1392237658-6614-1-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Feb 2014 12:57:23 -0800
Message-ID: <CALCETrUo_Um3LiEMfeYwPTOZf=ZGuRtzLrr8_pvd+STVMwoYJA@mail.gmail.com>
Subject: Re: [PATCH v15 10/10] do conditional fixmap of VVAR and HPET page
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

On Wed, Feb 12, 2014 at 12:40 PM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <Stefani Seibold stefani@seibold.net>
>
> This patch adds conditional fixmap of the VVAR and HPET pages for a 32
> bit kernel
>
> Signed-off-by: Stefani Seibold <Stefani Seibold stefani@seibold.net>

Looks good to me.

(Your git configuration is broken, though -- your signed-off-by line
and from line are broken.)

--Andy
