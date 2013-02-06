Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3BFKcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:32:24 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:51117 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3BFKcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:32:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Date: Wed, 06 Feb 2013 11:38:40 +0100
Message-ID: <1713890.Dj4ufUrfMM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=T+YJxkxyWJQ_SdsFHcY_Xv-SXy_mZNLe7a3CtDF-7gw@mail.gmail.com>
References: <cover.1359976493.git.viresh.kumar@linaro.org> <CAP245DUMnSMSoXo2JoMu1CgNROQ2YT7kd7e9svWoZ_EG2QLi+Q@mail.gmail.com> <CAKohpo=T+YJxkxyWJQ_SdsFHcY_Xv-SXy_mZNLe7a3CtDF-7gw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2013 03:45:58 PM Viresh Kumar wrote:
> On 6 February 2013 15:38, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> > On Wed, Feb 6, 2013 at 3:28 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> I have pushed the complete patchset here:
> >>
> >> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-updates
> >>
> >
> > Viresh, perhaps you should ask Stephen Rothwell to pull in your tree
> > to get some more testing before Rafael pulls it in for 3.10?
> 
> Its has been made clear by Rafael that these patches wouldn't make it for
> 3.9 (though i wanted them to :) ), and so once the merge window is over
> Rafael might pull them in and so they would reach Stephen's linux-next too...
> 
> I am not sure if sending a cpufreq pull request directly to Stephen is
> preferred.
> @Rafael: ??

You may do that, if you want, but that's slightly confusing.

Also the policy is that material which is not going to be included into v3.9
shouldn't be in linux-next before v3.9-rc1.

Moreover, for build testing it is sufficient to put it into a branch somewhere
at git.kernel.org (as you have already noticed :-)).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
