Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3FXLAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:00:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48932 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab3FXKvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:51:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show accumulated data of CPUs
Date: Mon, 24 Jun 2013 13:00:41 +0200
Message-ID: <4710866.fhlicB7Bsa@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponJ7WZ9pc20653gj_bPEAC_ZCA43XgZVPmNBcBs7pLFAQ@mail.gmail.com>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com> <3966081.PYqoVoQ0Wq@vostro.rjw.lan> <CAKohponJ7WZ9pc20653gj_bPEAC_ZCA43XgZVPmNBcBs7pLFAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 04:03:15 PM Viresh Kumar wrote:
> On 24 June 2013 15:50, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > My impression was that that new interface wouldn't be useful on all platforms
> > supported by cpufreq.  If that's the case, I'd rather not make changes in the
> > core code that are needed only to implement that new interface, at least to
> > start with.
> 
> Every platform might not have userspace software that would do some
> actions based on this. But, these are nice and useful stats to have.
> 
> They tell you a lot about how the hardware/governor/policies are
> behaving with load. And so will eventually help getting performance based
> on governor tunables for your platform. That's why I asked to put this in
> core as this should be pretty much useful.

OK, let's see how the code will look like.

Chanwoo, please prepare a v4 with the changes suggested by Viresh.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
