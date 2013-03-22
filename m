Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3CVMEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:04:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33406 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3CVMD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:03:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH V3 2/4] cpufreq: governor: Implement per policy instances of governors
Date: Fri, 22 Mar 2013 13:11:18 +0100
Message-ID: <1790330.ctnB4S9NpK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOh2x=n8G+g8EE-9mGovbiB-oXV3pP3bWUds8noATSc3LEYJ8A@mail.gmail.com>
References: <cover.1362381470.git.viresh.kumar@linaro.org> <1483775.d1txvSJx9o@vostro.rjw.lan> <CAOh2x=n8G+g8EE-9mGovbiB-oXV3pP3bWUds8noATSc3LEYJ8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 05:21:19 PM Viresh Kumar wrote:
> On Fri, Mar 22, 2013 at 5:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, March 22, 2013 07:50:54 AM Viresh Kumar wrote:
> 
> >> Hmm... I always thought fixups are way easy to review (and i still
> >> believe that's
> >> true) as they just contain what got changed and so people don't have to review
> >> whole patch again.
> >
> > They won't have to if you write in the preamble what the differences from
> > previous versions are.
> 
> You didn't get me.. How will the reviewer check if author has done what he
> is saying in preamble and he hasn't broken anything new?

Well, if the submitter wants to cheat, she/he certainly can this way, but
what's the benefit, honestly?  If the reviewer actually notices that there are
more differences than the submitter admits to, the consequences may be quite
unpleasant for the submitter (like the rejection of any future patches, for
example).  And mistakes are possible anyway (and the more patches you deal
with, the greater the chances of making a mistake are).

Thanks.
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
