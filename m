Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764918Ab3DDVc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:32:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56671 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764868Ab3DDVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:32:25 -0400
Date: Thu, 4 Apr 2013 23:32:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH V4 1/2] cpufreq: ondemand: allow custom
 powersave_bias_target handler to be registered
Message-ID: <20130404213220.GK32271@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Renninger <trenn@suse.de>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
 <1365092344-11310-2-git-send-email-jacob.shin@amd.com>
 <CAKohpom6BSJZc_ohgnjRTV2EBUAPy8TKVphtoRaNSt1wFP70uA@mail.gmail.com>
 <20130404171804.GA4696@jshin-Toonie>
 <20130404191225.GH32271@pd.tnic>
 <20130404202813.GA24479@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130404202813.GA24479@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 03:28:13PM -0500, Jacob Shin wrote:
> Ah, okay .. here is the fixup:
> 
> From 7236287faa1a499686c9aac1d3f3f224516a7bbf Mon Sep 17 00:00:00 2001
> From: Jacob Shin <jacob.shin@amd.com>
> Date: Tue, 2 Apr 2013 09:56:56 -0500
> Subject: [PATCH 1/2] cpufreq: ondemand: allow custom powersave_bias_target
>  handler to be registered
> 
> This allows for another [arch specific] driver to hook into existing
> powersave bias function of the ondemand governor. i.e. This allows AMD
> specific powersave bias function (in a separate AMD specific driver)
> to aid ondemand governor's frequency transition decisions.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
