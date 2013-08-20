Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3HTNx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:53:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51477 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab3HTNx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:53:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] cpufreq: Fixes for 3.12
Date: Tue, 20 Aug 2013 16:03:59 +0200
Message-ID: <1660632.57toTTMTf1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpomCaUvns+45qV-MdcxmRJ9fihdDf--BgH5uxEFqVnFPHQ@mail.gmail.com>
References: <cover.1376979090.git.viresh.kumar@linaro.org> <4207583.84U9qMI9uv@vostro.rjw.lan> <CAKohpomCaUvns+45qV-MdcxmRJ9fihdDf--BgH5uxEFqVnFPHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 06:07:14 PM Viresh Kumar wrote:
> On 20 August 2013 18:13, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Well, this looks good, but do we really need it in 3.12?  It doesn't look
> > like 3.12 will be missing these changes a lot?
> 
> Hmm.. If its too late for 3.12 we can skip them, but first two are bug
> fixes really (though nobody is affected as cpufreq_policy_list isn't used
> yet :) ) and other three are cleanups..
> 
> So, if there is any chance that we can queue them up for 3.12, it would
> be good.. but definitely not a must to have stuff. :)

OK, queued up for 3.12.  Hopefully, there won't be any fallout from [3/5].

Thanks,
Rafael

