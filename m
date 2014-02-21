Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaBUVKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:10:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58927 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbaBUVKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:10:21 -0500
Message-ID: <5307C0A0.9010708@zytor.com>
Date: Fri, 21 Feb 2014 13:09:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Jianguo Wu <wujianguo@huawei.com>, Andy Honig <ahonig@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] x86, kaslr: randomize module base load address
References: <20140221202110.GA29885@www.outflux.net>	<20140221123658.5752f75eea6506d17bfa313b@linux-foundation.org> <CAGXu5jLGBJp7oKXjausV70bXF-RTVDXxdZriS0cJ7X6NO90Ybg@mail.gmail.com>
In-Reply-To: <CAGXu5jLGBJp7oKXjausV70bXF-RTVDXxdZriS0cJ7X6NO90Ybg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 01:05 PM, Kees Cook wrote:
> 
> I've been slapped down for adding more config options in the past, and
> I think it's unlikely that people using CONFIG_RANDOMIZE_BASE won't
> want the modules base randomized too. I think this is a safe default,
> but if you see it as a requirement, I can change it.
> 

No, but I could totally see people wanting to randomize modules but not
the main kernel.  Why?  Because module addresses are already dynamic, so
there is no breakage.  Whether or not it is *useful* is another matter.

	-hpa

