Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801Ab3DCRac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:30:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54002 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab3DCRaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:30:30 -0400
Date: Wed, 3 Apr 2013 19:30:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Renninger <trenn@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V3 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130403173028.GB4716@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>, Thomas Renninger <trenn@suse.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>
References: <1364926304-1799-1-git-send-email-jacob.shin@amd.com>
 <20130402192352.GC17675@pd.tnic>
 <20130402200337.GA17919@jshin-Toonie>
 <2932884.BNCEuERbdR@skinner.arch.suse.de>
 <20130402210124.GI17675@pd.tnic>
 <20130403165324.GB17919@jshin-Toonie>
 <20130403170456.GA4723@pd.tnic>
 <20130403171738.GC17919@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130403171738.GC17919@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 12:17:38PM -0500, Jacob Shin wrote:
> Writing 0 to powersave_bias or unloading the AMD driver could do that.
>
> When the AMD driver loads, it will give a sane default value to
> powersave_bias to enable it, when it unloads, it will put it back to
> 0.

... and on systems without hw feedback, it will keep powersave_bias to 0
by default, retaining the old behavior.

Yeah, sounds like a plan.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
