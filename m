Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3ILKp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:45:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48961 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3ILKpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:45:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
Date: Thu, 12 Sep 2013 12:56:58 +0200
Message-ID: <8571427.B6ubx1als5@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpokiBoKxCMeD8a6YgMPZn1NXScvB0=5W3sB_OSZhJO2a1g@mail.gmail.com>
References: <cover.1378963070.git.viresh.kumar@linaro.org> <5076102.HGJgP9ualc@vostro.rjw.lan> <CAKohpokiBoKxCMeD8a6YgMPZn1NXScvB0=5W3sB_OSZhJO2a1g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 12, 2013 04:13:03 PM Viresh Kumar wrote:
> On 12 September 2013 16:17, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Please resend.  And I honestly don't think that [1-3/5] are fixes and
> > [4/5] is not needed any more.
> 
> Okay, I will resend 5/5.. I didn't get you last two statements clearly :(
> - don't think that [1-3/5] are fixes: You meant they are cleanups rather?

Yes.

> Yes, and that's why I asked you to take those on for 3.13 and not for 12..

Ah, sorry, I must have overlooked that.  I didn't say I wasn't going to take
them, though.

> - [4/5] is not needed any more: 4/5 is already applied by you and it came
> from Rafael.. I reinvented the wheel, nothing more. And so it is not required
> anymore :)

Surely from Srivatsa?

Thanks,
Rafael

