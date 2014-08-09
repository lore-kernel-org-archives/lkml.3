Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaHIASA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:18:00 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64324 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaHIAR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:17:58 -0400
Message-ID: <53E568B2.40206@linaro.org>
Date: Fri, 08 Aug 2014 17:17:54 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Johan Rudholm <jrudholm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 3.15 mmc related ext4 corruption with qemu-system-arm
References: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>	<53E53DCD.2020707@linaro.org> <CAGXu5j+Q8F8TKy8sxCL6pxD-cni4RKxy46HwsCSZE+mWpuyn-g@mail.gmail.com>
In-Reply-To: <CAGXu5j+Q8F8TKy8sxCL6pxD-cni4RKxy46HwsCSZE+mWpuyn-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 05:15 PM, Kees Cook wrote:
> On Fri, Aug 8, 2014 at 2:14 PM, John Stultz <john.stultz@linaro.org> wrote:
>> I sunk a couple of weeks bisecting to try to narrow down the more
>> sporadic issue, but was unsuccessful past the initial commit above.
>> Since then I've been far too swamped to spend any more time on it. Even
>> so, its a *major* pain for testing but it seems like no one else really
>> cares?
> I'm in the same boat as far as poor bisection results. :(
>
> However, I keep using the 3-patch mmci fix series from Ulf, and
> haven't hit any trouble with them. Though perhaps I'm just getting
> lucky?
>
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=arm/fix-mmci

I guess I'll give that another shot then.

thanks
-john

