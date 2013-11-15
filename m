Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3KOBsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:48:53 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:65452 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3KOBsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:48:45 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131115013248.GA6541@kroah.com>
References: <1384463364-28864-1-git-send-email-olof@lixom.net>
	<20131115013248.GA6541@kroah.com>
Date: Thu, 14 Nov 2013 17:48:42 -0800
Message-ID: <CAOesGMh2HvyHimo8=LyZ-R_W_0=XtB37hbnbx_hk0Wq+4CBhuA@mail.gmail.com>
Subject: Re: [PATCH] video: exynos_mipi_dsim: Remove unused variable
From: Olof Johansson <olof@lixom.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        InKi Dae <inki.dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 5:32 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 14, 2013 at 01:09:24PM -0800, Olof Johansson wrote:
>> commit 7e0be9f9f7cba3356f75b86737dbe3a005da067e ('video: exynos_mipi_dsim:
>> Use the generic PHY driver') resulted in a warning about an unused
>> variable:
>>
>> drivers/video/exynos/exynos_mipi_dsi.c:144:26: warning: unused variable
>>     'pdev' [-Wunused-variable]
>>
>> It is indeed unused; remove it.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  drivers/video/exynos/exynos_mipi_dsi.c |    1 -
>>  1 file changed, 1 deletion(-)
>
> I had to take the offending patch through my tree due to the phy
> changes, but I'm not the maintainer of it, nor the video mantainer, so I
> can't really take this patch through my trees, sorry.

I was wondering why you had signed off, since it didn't follow the
regular path. Makes sense.

So, looks like most historical patches to this file have gone through
Andrew. Can I get an ack from someone and just take it through arm-soc
in this case, please? Inki?


-Olof
