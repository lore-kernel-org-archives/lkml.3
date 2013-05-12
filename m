Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3ELPMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:12:18 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:45839 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3ELPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:12:16 -0400
MIME-Version: 1.0
In-Reply-To: <1368173847-5661-21-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
	<1368173847-5661-21-git-send-email-wsa@the-dreams.de>
Date: Sun, 12 May 2013 20:42:15 +0530
X-Google-Sender-Auth: SjJoI38rlETx2wVH2llNXaDiI00
Message-ID: <CAOh2x=k6ugjuNo7XUHFhqwN=eQBe-F6nVyafsMkf30fRTxirdw@mail.gmail.com>
Subject: Re: [RFC 20/42] drivers/pwm: don't check resource with devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Prisk <linux@prisktech.co.nz>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
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
>  drivers/pwm/pwm-spear.c    |    7 +------

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
