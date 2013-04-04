Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764606Ab3DDTXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:23:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41333 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764588Ab3DDTX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:23:29 -0400
Date: Thu, 4 Apr 2013 21:23:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH V4 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130404192323.GI32271@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Thomas Renninger <trenn@suse.de>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
 <1365092344-11310-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365092344-11310-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 11:19:04AM -0500, Jacob Shin wrote:
> Future AMD processors, starting with Family 16h, can provide software
> with feedback on how the workload may respond to frequency change --
> memory-bound workloads will not benefit from higher frequency, where
> as compute-bound workloads will. This patch enables this "frequency
> sensitivity feedback" to aid the ondemand governor to make better
> frequency change decisions by hooking into the powersave bias.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Looks good to me.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
