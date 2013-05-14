Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3ENP5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:57:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41192 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab3ENP5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:57:21 -0400
Message-ID: <51925EDC.2080307@linaro.org>
Date: Tue, 14 May 2013 08:57:16 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
References: <5191EBA7.9010303@cn.fujitsu.com>
In-Reply-To: <5191EBA7.9010303@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 12:45 AM, Gu Zheng wrote:
>  From 18072c1c3506a7e37ee485307a2c343efe5af4d0 Mon Sep 17 00:00:00 2001
> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Date: Mon, 13 May 2013 15:45:24 +0900
> Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
>
> Introduce a new timestamp function local_time_seconds() to hide the conversion of system time in UTC to local time seconds.

So, why is this useful/needed?

thanks
-john

