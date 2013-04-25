Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab3DZIh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:37:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44813 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab3DZIhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:37:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, robin.randhawa@arm.com,
        Ben Dooks <ben-linux@fluff.org>, linux-pm@vger.kernel.org,
        patches@linaro.org, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
Date: Thu, 25 Apr 2013 20:12:29 +0200
Message-ID: <1615834.7iOsapYTqY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51795E53.5030908@samsung.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org> <2264237.NUtkmvZG3W@vostro.rjw.lan> <51795E53.5030908@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 26, 2013 01:48:19 AM Kukjin Kim wrote:
> On 04/24/13 07:59, Rafael J. Wysocki wrote:
> 
> [...]
> 
> >> Rafael, please take this patch with my ack in your tree, sorry for noise.
> >>
> >> Acked-by: Kukjin Kim<kgene.kim@samsung.com>
> >>
> >> If any problems, please kindly let me know.
> >
> > Well, I suppose I can take the original patch, but then it will conflict with
> > your tree during merge.  Is that not a problem?
> >
> I think, some conflicts can be occurred but if so, we can fix it before 
> merge window.

Well, how exactly would you like to address them?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
