Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3JYOAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:00:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54144 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab3JYOAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:00:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 Resend 00/34] CPUFreq Cleanup Part III
Date: Fri, 25 Oct 2013 16:12:25 +0200
Message-ID: <6700479.xPkgXUV5KL@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpokJrj_ZbCPUw4ZpfOWgsDvqxLH9j41eQVC7V7Ny4xE8mA@mail.gmail.com>
References: <cover.1382104514.git.viresh.kumar@linaro.org> <14730355.7hm7UiW5IU@vostro.rjw.lan> <CAKohpokJrj_ZbCPUw4ZpfOWgsDvqxLH9j41eQVC7V7Ny4xE8mA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 25, 2013 07:25:45 PM Viresh Kumar wrote:
> On 25 October 2013 18:26, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Having considered that a bit I think that I'd prefer one patch doing all of
> > these changes in one go (and with all applicable ACKs collected), one of the
> > reasons being that if it is necessary to revert that stuff, whatever the
> > reason, it will be much easier to do that with just one commit than with
> > 34 of them.
> 
> With a similar reason I think the probability is more that a revert might
> be required for individual drivers as they may need to switch back to
> ->target() instead of ->target_index() and so keeping them separate
> might be better.
> 
> In case we need to revert all patches due to some breakage, we can
> always do that in a single commit if required.
> 
> What do you say?

If I need to revert the first patch, then I'll need to revert all of them.

Also, if you do the same change in multiple places it actually is easier
to handle it pretty much regardless of the angle you look at that from
if that's done in one patch.  Please do that.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
