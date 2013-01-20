Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3ATMyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 07:54:00 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51918 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3ATMx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 07:53:58 -0500
MIME-Version: 1.0
In-Reply-To: <1358386938-13577-1-git-send-email-amit.daniel@samsung.com>
References: <CADGdYn4CeWB5zHuHrfSLYsyOCA_zcSgm9LHTwtei1zAhfmDJNQ@mail.gmail.com>
	<1358386938-13577-1-git-send-email-amit.daniel@samsung.com>
Date: Sun, 20 Jan 2013 18:23:57 +0530
Message-ID: <CAM=Q2ctj3-_WZQM9iH==nPvR8hQTG33743+McjrHqzb_FnJsJw@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] thermal: exynos: Miscellaneous fixes to support
 falling threshold interrupt
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        jonghwa3.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, durgadoss.r@intel.com, joe@perches.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/13, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> Below fixes are done to support falling threshold interrupt,
> * Falling interrupt status macro corrected according to exynos5 data sheet.
> * The get trend function modified to calculate trip temperature correctly.
> * The clearing of interrupt status in the isr is now done after handling
>   the event that caused the interrupt.
One fix per patch would have been better.

However not particular.

Also are they applicable to older kernels?

>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
