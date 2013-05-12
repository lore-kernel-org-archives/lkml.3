Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3ELPLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:11:44 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51847 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3ELPLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:11:43 -0400
MIME-Version: 1.0
In-Reply-To: <1368173847-5661-23-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
	<1368173847-5661-23-git-send-email-wsa@the-dreams.de>
Date: Sun, 12 May 2013 20:41:42 +0530
X-Google-Sender-Auth: lIhN-Rt44T9kXvOa6keTdcW-RTE
Message-ID: <CAOh2x==r81YBYKWtPSUs=E35P_yfbCYjUib6EbPttYHME22cww@mail.gmail.com>
Subject: Re: [RFC 22/42] drivers/rtc: don't check resource with devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 1:47 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/rtc/rtc-spear.c  |    7 +------

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
