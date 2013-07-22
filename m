Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab3GVE1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 00:27:49 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60361 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3GVE1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 00:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <1374256055-26894-2-git-send-email-broonie@kernel.org>
References: <1374256055-26894-1-git-send-email-broonie@kernel.org>
	<1374256055-26894-2-git-send-email-broonie@kernel.org>
Date: Mon, 22 Jul 2013 09:57:47 +0530
Message-ID: <CAKohpok+jZkVpOR28RjX-8RAb4ZYC097wMXiac45MHWmqsrS4w@mail.gmail.com>
Subject: Re: [PATCH 2/2] extcon: adc-jack: Use power efficient workqueue
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
>  drivers/extcon/extcon-adc-jack.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
