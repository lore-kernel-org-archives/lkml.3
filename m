Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3AOTsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:48:46 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46599 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab3AOTsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:48:45 -0500
Message-ID: <50F5B29A.7050703@linaro.org>
Date: Tue, 15 Jan 2013 11:48:42 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 1/3] timekeeping: Add persistent_clock_exist flag
References: <1358266189-8812-1-git-send-email-feng.tang@intel.com>
In-Reply-To: <1358266189-8812-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 08:09 AM, Feng Tang wrote:
> In current kernel, there are several places which need to check
> whether there is a persistent clock for the platform. Current check
> is done by calling the read_persistent_clock() and validating its
> return value.
>
> So one optimization is to do the check only once in timekeeping_init(),
> and use a flag persistent_clock_exist to record it.
>
> v2: Add a has_persistent_clock() helper function, as suggested by John.

Applied! Thanks
-john

