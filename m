Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaCLW4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:56:46 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:40322 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaCLW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <1394664680-17799-1-git-send-email-stefani@seibold.net>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 15:56:24 -0700
Message-ID: <CALCETrViaEdPsZO_xKaoihkNzayB+vhwpAO0YvNbfXZH2tOLUg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Improve 32 bit vDSO time
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
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since no one seems to object to the latest patch I sent out, wouldn't
it make more sense to base this on top of my patch?

--Andy

On Wed, Mar 12, 2014 at 3:51 PM, Stefani Seibold <stefani@seibold.net> wrote:
> This patch bring some improvments to the vDSO 32 bit:
>
> - undef some kernel configs which increase the code size of the VDSO
> - remove vsyscall and prevent wrong conditional VVAR_PAGE mapping
> - handle VDSO larger than a page
>
> The patch set is agains tip 7ed5ee279499a02bf35c77f0a91d657c24f6474e



-- 
Andy Lutomirski
AMA Capital Management, LLC
