Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3EPLQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:16:01 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33769 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3EPLP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <1368702961-4325-4-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
	<1368702961-4325-4-git-send-email-wsa@the-dreams.de>
Date: Thu, 16 May 2013 16:45:56 +0530
Message-ID: <CAKohpo=WoERP1MVMQ4APcwtf1yVjrPYGuejb1mk4=rM7buXeCw@mail.gmail.com>
Subject: Re: [PATCH 03/33] drivers/cpufreq: don't check resource with devm_ioremap_resource
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2013 16:45, Wolfram Sang <wsa@the-dreams.de> wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/cpufreq/kirkwood-cpufreq.c |    4 ----
>  1 file changed, 4 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
