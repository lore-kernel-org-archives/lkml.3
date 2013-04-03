Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807Ab3DCFMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:12:55 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34615 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669Ab3DCFMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <1364926304-1799-2-git-send-email-jacob.shin@amd.com>
References: <1364926304-1799-1-git-send-email-jacob.shin@amd.com>
	<1364926304-1799-2-git-send-email-jacob.shin@amd.com>
Date: Wed, 3 Apr 2013 10:42:51 +0530
Message-ID: <CAKohpomQN2endmNtvVS3JrqqPbyQpaZuVbiJ_hpM5SFLfDNRww@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] cpufreq: ondemand: allow custom
 powersave_bias_target handler to be registered
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 April 2013 23:41, Jacob Shin <jacob.shin@amd.com> wrote:
> This allows for another [arch specific] driver to hook into existing
> powersave bias function of the ondemand governor. i.e. This allows AMD
> specific powersave bias function (in a separate AMD specific driver)
> to aid ondemand governor's frequency transition deicisions.
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  drivers/cpufreq/cpufreq_governor.h |    3 +++
>  drivers/cpufreq/cpufreq_ondemand.c |   32 ++++++++++++++++++++++++--------
>  2 files changed, 27 insertions(+), 8 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
