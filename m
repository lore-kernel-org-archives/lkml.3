Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3ITNTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:19:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58739 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab3ITNS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:18:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
Date: Fri, 20 Sep 2013 15:30:08 +0200
Message-ID: <3290463.fBbGMovmdx@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAE9FiQU5PD4asdE3=sBSnLK8fwPT8vK81FAOuYtAWj_3ruyS0g@mail.gmail.com>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org> <CAKohpom-3orEns00DC2=uk4pgV_xnfRpM1hrdyK9pjPUEgBXrA@mail.gmail.com> <CAE9FiQU5PD4asdE3=sBSnLK8fwPT8vK81FAOuYtAWj_3ruyS0g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 19, 2013 10:30:04 PM Yinghai Lu wrote:
> On Thu, Sep 19, 2013 at 9:23 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 20 September 2013 07:01, Yinghai Lu <yinghai@kernel.org> wrote:
> >> Sorry,  looks like this one is not enough.

Well, I've already applied this one and it makes sense to me anyway.

> >> please let me know if you prefer me send addon patch
> >> or revised one.
> >
> > Atleast you can let us know what the problem is? And then we
> > can decide on that.. But anyway, you can send a new patch
> > based over latest linux-next (which will have your original patch),
> > and then leave it onto Rafael to merge it or have two patches..
> > (though I am quite sure he will not drop anything now, unless its
> > too screwed.., at worst he might revert it..)..
> 
> looks like the crash is intermittent..., so i thought that patch fixed
> the problem.
> but later I found other suspicious print out.

So, does it mean that the $subject patch fixes the issue for you to some
extent, but more changes are necessary to make it go away completely?

> please check new one:
> 
> https://patchwork.kernel.org/patch/2915181/

I see.

I *think* we can just drop the module requesting stuff entirely, because it
doesn't seem to work anyway and udev is handling this for us.

Thanks,
Rafael

