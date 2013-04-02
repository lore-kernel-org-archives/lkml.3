Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328Ab3DBVBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:01:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37124 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761785Ab3DBVBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:01:38 -0400
Date: Tue, 2 Apr 2013 23:01:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Renninger <trenn@suse.de>
Cc: Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V3 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130402210124.GI17675@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Renninger <trenn@suse.de>, Jacob Shin <jacob.shin@amd.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>
References: <1364926304-1799-1-git-send-email-jacob.shin@amd.com>
 <20130402192352.GC17675@pd.tnic>
 <20130402200337.GA17919@jshin-Toonie>
 <2932884.BNCEuERbdR@skinner.arch.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2932884.BNCEuERbdR@skinner.arch.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 10:51:51PM +0200, Thomas Renninger wrote:
> Yep, if you want anyone to make use of this, it should better get
> embedded in more general, at least general ondemand code.

Yeah, it all sounds like we want to enable this by default on systems
which support it. Maybe with an off-switch for people who want plain
ondemand decisions.

The remaining systems with ripped out powersave_bias would get plain
ondemand governor decisions. Provided, of course, nobody uses
powersave_bias and the functionality doesn't make any sense anyway.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
