Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3BDMcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:32:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34583 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab3BDMcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:32:31 -0500
Date: Mon, 4 Feb 2013 13:32:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130204123221.GA22340@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
	Steve.Bannister@arm.com, Liviu.Dudau@arm.com
References: <cover.1359976493.git.viresh.kumar@linaro.org>
 <5808458.pvV2iHpBWm@vostro.rjw.lan>
 <CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 05:54:18PM +0530, Viresh Kumar wrote:
> One important point i would like to highlight is: governors directory
> would be present in cpu/cpu*/cpufreq/ now instead of cpu/cpufreq/.

Uh, hold on, isn't this breaking a bunch of userspace with this move?
Also, on all those other systems which don't need per-policy governors,
we probably don't need this. So maybe this should be made optional, to
be enabled by a config option IMO...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
