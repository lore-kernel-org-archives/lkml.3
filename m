Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3KYXRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:17:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47934 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab3KYXRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:17:53 -0500
Message-ID: <5293DA66.6050902@zytor.com>
Date: Mon, 25 Nov 2013 15:16:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olofj@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] use -fstack-protector-strong
References: <20131125221400.GA11041@www.outflux.net>
In-Reply-To: <20131125221400.GA11041@www.outflux.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 02:14 PM, Kees Cook wrote:
> Build the kernel with -fstack-protector-strong when it is available
> (gcc 4.9 and later). This increases the coverage of the stack protector
> without the heavy performance hit of -fstack-protector-all.

What is the difference between the various options?

	-hpa


