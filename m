Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3FXFxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 01:53:17 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:48749 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3FXFxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 01:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <201306230108.25639.heiko@sntech.de>
References: <201306230108.25639.heiko@sntech.de>
Date: Mon, 24 Jun 2013 11:23:14 +0530
Message-ID: <CAKohpomy6wbfQDq1JVBw+aUummjaPSOjNAHwFpsd98HUz5hPBA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: s3c2416: fix forgotten driver_data conversions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 June 2013 04:38, Heiko Stübner <heiko@sntech.de> wrote:
> Commit 5070158804b5 (cpufreq: rename index as driver_data in
> cpufreq_frequency_table) renamed the index field to driver_data.
>
> But it seems some uses in the s3c2416 driver were forgotten.
>
> So convert the last index users to read driver_data.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/cpufreq/s3c2416-cpufreq.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

So sorry for this mistake. Applied.
