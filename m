Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaBBW1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 17:27:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50953 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbaBBW1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 17:27:31 -0500
Message-ID: <52EEC632.1080508@zytor.com>
Date: Sun, 02 Feb 2014 14:26:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: stefani@seibold.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v9 8/8] Add 32 bit VDSO time support for 64 bit kernel
References: <1391377293-9458-1-git-send-email-stefani@seibold.net> <1391377293-9458-9-git-send-email-stefani@seibold.net>
In-Reply-To: <1391377293-9458-9-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 01:41 PM, stefani@seibold.net wrote:
> +
> +struct api_timespec {
> +	long	tv_sec;		/* seconds */
> +	long	tv_nsec;	/* microseconds */
> +};
> +

/* nanoseconds */  ;)

	-hpa

