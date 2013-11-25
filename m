Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab3KYOQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:16:47 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61717 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab3KYOQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:16:44 -0500
MIME-Version: 1.0
In-Reply-To: <1385386726-4070-1-git-send-email-jhbird.choi@samsung.com>
References: <1385386726-4070-1-git-send-email-jhbird.choi@samsung.com>
Date: Mon, 25 Nov 2013 19:46:43 +0530
Message-ID: <CAKohpondGkOdAz+Uf2SLS6GJ=G-xH2UuVZiSe6XVHvaNs+GKBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: s5pv210: Frequency lock should be considered
 in hibernation also.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2013 19:08, Jonghwan Choi <jhbird.choi@gmail.com> wrote:
> The Frequency lock value should be higher or same than the booting frequency,
> which is set by the bootloader. To eliminate possible inconsistency
> in frequency, we save and restore frequency during suspend & resume
> and disable CPUFREQ activity. This should be considered in hibernation also.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/cpufreq/s5pv210-cpufreq.c | 2 ++
>  1 file changed, 2 insertions(+)

Hi,

Can you please test this patchset:

[PATCH V3 0/6] cpufreq: suspend early/resume late

Then, we wouldn't require the routine you modified and hence
your patchset :)
