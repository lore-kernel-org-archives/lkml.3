Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaAIQ0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:26:15 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56651 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaAIQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:26:10 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <aaadbfa341a881c8250f2d23bc77062228d2e70b.1389279793.git.viresh.kumar@linaro.org>
References: <aaadbfa341a881c8250f2d23bc77062228d2e70b.1389279793.git.viresh.kumar@linaro.org>
Date: Thu, 9 Jan 2014 08:26:08 -0800
Message-ID: <CAOesGMgQgOUxbj=0=AYx2pN4mh5HoDcW4p1W89+kvNtXpFmYxA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: SA1100: Create dummy clk_get_rate() to avoid
 build failures
From: Olof Johansson <olof@lixom.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 7:08 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> There are some parts of common kernel which would be using routines like
> clk_get_rate() on some platforms. Currently these wouldn't be called for SA1100
> boards but we need these routines for successful builds of these boards.
>
> So, this patch creates a dummy clk_get_rate() routine which is being used by
> cpufreq core. More dummy routines might be added later if there is a need for
> that.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Reported-by: <Olof Johansson> olof@lixom.net

That's not the right format.

-Olof
