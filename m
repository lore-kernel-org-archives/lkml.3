Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab3CMVee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:34:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35819 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597Ab3CMVec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:34:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH V3 4/4] cpufreq: Add Kconfig option to enable/disable have_multiple_policies
Date: Wed, 13 Mar 2013 22:41:36 +0100
Message-ID: <3174774.7AKCbYrzc6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpompsA5bR6TauM7Wa6ciLxYYc7GdpN1NXdHF_WbP2ki=qA@mail.gmail.com>
References: <cover.1362381470.git.viresh.kumar@linaro.org> <1687194.MelaMkNoiM@vostro.rjw.lan> <CAKohpompsA5bR6TauM7Wa6ciLxYYc7GdpN1NXdHF_WbP2ki=qA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 12, 2013 08:55:12 AM Viresh Kumar wrote:
> On 12 March 2013 07:38, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > One more question before I apply it.
> >
> > Is there any architecture/platform that will set
> > CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES and keep have_multiple_policies unset
> > at the same time?
> 
> No, they are redundant. That's why i have been forcing to drop this patch.

I see.

What about having the Kconfig option alone, however?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
