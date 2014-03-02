Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaCBVD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:03:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45805 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaCBVD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:03:58 -0500
Message-ID: <53139C56.9060308@zytor.com>
Date: Sun, 02 Mar 2014 13:02:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>
CC: Stefani Seibold <stefani@seibold.net>,
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
Subject: Re: [PATCH v21 00/12] Add 32 bit VDSO time function support
References: <1393752020-6740-1-git-send-email-stefani@seibold.net> <20140302104744.GB18257@gmail.com> <CALCETrWgtWt8EjQpx0DdDq076gcXfiWAw7NnO6z9Kp3Ongj2RA@mail.gmail.com>
In-Reply-To: <CALCETrWgtWt8EjQpx0DdDq076gcXfiWAw7NnO6z9Kp3Ongj2RA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 08:32 AM, Andy Lutomirski wrote:
> 
> OTOH, hpa may prefer incremental patches, now that this lives in tip.
> 

The branch currently in -tip is dead, so it is not an issue either way.

	-hpa


