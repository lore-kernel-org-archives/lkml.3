Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3CVCoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:44:07 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:36661 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3CVCoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <1363911022-7786-1-git-send-email-silviupopescu1990@gmail.com>
References: <1363911022-7786-1-git-send-email-silviupopescu1990@gmail.com>
Date: Fri, 22 Mar 2013 08:14:03 +0530
X-Google-Sender-Auth: GievxjFwOIrYUVx09U8rGom4mig
Message-ID: <CAOh2x=kh7C-5S0KYy7OQRhoZRzk6rgSPBYcVjd9RN5ck41Mx4w@mail.gmail.com>
Subject: Re: [PATCH] drivers: cpufreq: kirkwood: fix coccicheck warnings
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: cpufreq@vger.kernel.org, rjw@sisk.pl, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 5:40 AM, Silviu-Mihai Popescu
<silviupopescu1990@gmail.com> wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
>
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
>
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>  drivers/cpufreq/kirkwood-cpufreq.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
