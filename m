Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaCBKrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 05:47:49 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:57091 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaCBKrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 05:47:48 -0500
Date: Sun, 2 Mar 2014 11:47:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v21 00/12] Add 32 bit VDSO time function support
Message-ID: <20140302104744.GB18257@gmail.com>
References: <1393752020-6740-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393752020-6740-1-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefani Seibold <stefani@seibold.net> wrote:

> This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> and vdso_time() to the 32 bit VDSO.

What I'm missing from all the series is any trace of the significant 
review and debug work that Andy Lutomirski did for the series. Please 
add Acked-by or Reviewed-by tags to credit his contributions, as 
appropriate. (if Andy is fine with that.)

Thanks,

	Ingo
