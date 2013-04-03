Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762491Ab3DCRFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:05:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45263 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580Ab3DCRE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:04:58 -0400
Date: Wed, 3 Apr 2013 19:04:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Renninger <trenn@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V3 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130403170456.GA4723@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130403165324.GB17919@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 11:53:24AM -0500, Jacob Shin wrote:
> Then Thomas, Boris, would it be acceptable if enable the frequency
> feedback feature by default with a sane powersave_bias tunable value?
> And also add proper documentation for both vanila powersave_bias
> and powersave_bias with AMD frequency sensitivity loaded to
> Documentation/cpu-freq/ondemand ?

Yeah, this was what I was proposing, basically. The only question here
is, would anyone want to disable freq decisions on systems with hw
feedback? If yes, then you'd need to be able to disable the feedback
thing, maybe have a magic value for powersave_bias...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
