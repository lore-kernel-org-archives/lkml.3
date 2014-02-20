Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaBTXLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:11:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46145 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbaBTXLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:11:51 -0500
Message-ID: <53068B7B.9090407@zytor.com>
Date: Thu, 20 Feb 2014 15:10:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH v20 00/10] Final: Add 32 bit VDSO time function support
References: <1392800951-2683-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1392800951-2683-1-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 01:09 AM, Stefani Seibold wrote:
> 
> This kind of helper must be integrated into glibc, for x86 64 bit and
> PowerPC it is already there.
> 

Who is doing the glibc work?

	-hpa


