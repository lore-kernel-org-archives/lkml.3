Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaBBVrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:47:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50657 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbaBBVrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:47:23 -0500
Message-ID: <52EEBC97.50509@zytor.com>
Date: Sun, 02 Feb 2014 13:45:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: stefani@seibold.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v9 7/8] Add 32 bit VDSO time support for 32 bit kernel
References: <1391377293-9458-1-git-send-email-stefani@seibold.net> <1391377293-9458-8-git-send-email-stefani@seibold.net>
In-Reply-To: <1391377293-9458-8-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 01:41 PM, stefani@seibold.net wrote:
> @@ -19,11 +22,14 @@ ENTRY(__kernel_vsyscall);
>   */
>  VERSION
>  {
> -	LINUX_2.5 {
> +	LINUX_2.6 {
>  	global:

Why are you changing the version number?  This will, at least in theory,
break libcs from a certain time period.  The version number should only
be changed when there is an ABI-level incompatible change.

	-hpa


