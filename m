Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab3HNNDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:03:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42437 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab3HNNDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:03:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] cpufreq: sa11x0: cleanups for 3.13
Date: Wed, 14 Aug 2013 15:14:06 +0200
Message-ID: <1472734.1FogUomyWU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokOmv+CcL61dzkMgTNxY5rKb4A863CUAX_Jav4KyHF3DA@mail.gmail.com>
References: <cover.1376392060.git.viresh.kumar@linaro.org> <1437762.edDpfxPldn@vostro.rjw.lan> <CAKohpokOmv+CcL61dzkMgTNxY5rKb4A863CUAX_Jav4KyHF3DA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 14, 2013 07:56:44 AM Viresh Kumar wrote:
> On 14 August 2013 01:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, August 13, 2013 07:01:04 PM Viresh Kumar wrote:
> 
> > Are the three patches in this series prerequisite for the big target_index
> > one?  If so, I think they can go into 3.12 actually, if they are ACKed by the
> > appropriate platform maintainers.
> 
> Yes, but they depend on cpufreq_table_validate_and_show() which
> will also go in 3.13 and so these will be made part of that series in
> future..

OK

