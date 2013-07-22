Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3GVE1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 00:27:37 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59546 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3GVE1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 00:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <1374256055-26894-1-git-send-email-broonie@kernel.org>
References: <1374256055-26894-1-git-send-email-broonie@kernel.org>
Date: Mon, 22 Jul 2013 09:57:35 +0530
Message-ID: <CAKohpo=4NFNB6XVqjiqw2vMAWgiOLZv=OWKYtcC7JBw1eNX6Sg@mail.gmail.com>
Subject: Re: [PATCH 1/2] extcon: gpio: Use power efficient workqueue for debounce
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 July 2013 23:17, Mark Brown <broonie@kernel.org> wrote:
> From: Mark Brown <broonie@linaro.org>
>
> The debounce timeout is generally quite long and the work not performance
> critical so allow the scheduler to run the work anywhere rather than in
> the normal per-CPU workqueue.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/extcon/extcon-gpio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
