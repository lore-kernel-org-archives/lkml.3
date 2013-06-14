Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3FNQlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:41:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49676 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752549Ab3FNQli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:41:38 -0400
Message-ID: <1371228095.31941.49.camel@joe-AO722>
Subject: Re: [PATCH] power: Include additional information in pm_print_times
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Date: Fri, 14 Jun 2013 09:41:35 -0700
In-Reply-To: <1371227625-3141-1-git-send-email-shuah.kh@samsung.com>
References: <1371227625-3141-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 10:33 -0600, Shuah Khan wrote:
> Change __device_suspend() path to include driver name and the ops that
> get run for a device.
[]
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
[]
> -static ktime_t initcall_debug_start(struct device *dev)
> +static ktime_t initcall_debug_start(struct device *dev, char *info)
>  {
>  	ktime_t calltime = ktime_set(0, 0);
>  
>  	if (pm_print_times_enabled) {
> -		pr_info("calling  %s+ @ %i, parent: %s\n",
> +		pr_info("calling %s+ @ %i, parent: %s driver: %s %s\n",

dev_info(dev, etc...


