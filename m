Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3FFTwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:52:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:52:00 -0400
Date: Thu, 6 Jun 2013 12:51:59 -0700
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "'Eric Piel'" <eric.piel@tremplin-utc.net>,
        "'Dimitri Sivanich'" <sivanich@sgi.com>, "'Robin Holt'" <holt@sgi.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: Re: [PATCH V3] rtc: rtc-pcf2123: replace strict_strtoul() with
 kstrtoul()
Message-ID: <20130606195159.GA13011@kroah.com>
References: <001201ce60d9$c815e190$5841a4b0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001201ce60d9$c815e190$5841a4b0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 01:12:52PM +0900, Jingoo Han wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Changes since v1:
> - Splitted to two sequential checks.
> - Added Andy Shevchenko's Reviewed-by.
> 
> Changes since v1:
> - Used return code from kstrtoul().
> 
>  drivers/rtc/rtc-pcf2123.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)

I'm not the drivers/rtc/ maintainer, why send this to me?

greg k-h
