Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaBCVHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:07:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54996 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaBCVH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:07:28 -0500
Message-ID: <52F0050C.6040108@wwwdotorg.org>
Date: Mon, 03 Feb 2014 14:07:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, daniel.lezcano@linaro.org,
        tglx@linutronix.de, thierry.reding@gmail.com, abrestic@chromium.org,
        dgreid@chromium.org, katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
References: <1391203779-5676-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1391203779-5676-1-git-send-email-achew@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 02:29 PM, Andrew Chew wrote:
> There are some differences between tegra20's timer registers and tegra30's
> (and later).  For one thing, the watchdogs don't seem to be present in
> tegra20.  Add this compatibility string in order to be able to distinguish
> whether the watchdogs are there or not.

Acked-by: Stephen Warren <swarren@nvidia.com>

