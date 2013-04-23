Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3DWWvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:51:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42207 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab3DWWvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:51:22 -0400
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
Date: Wed, 24 Apr 2013 00:59:26 +0200
Message-ID: <2264237.NUtkmvZG3W@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5176A807.2090005@samsung.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org> <1769336.FkfMpuXqqb@vostro.rjw.lan> <5176A807.2090005@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 24, 2013 12:25:59 AM Kukjin Kim wrote:
> On 04/05/13 20:36, Rafael J. Wysocki wrote:
> > On Friday, April 05, 2013 12:36:34 PM Viresh Kumar wrote:
> >> On 5 April 2013 12:18, Kukjin Kim<kgene.kim@samsung.com>  wrote:
> >>> Basically, this moving looks good to me, but should be re-worked based on
> >>> for-next of samsung tree because this touches too many samsung stuff so this
> >>> should be sent to upstream via samsung tree.
> >>
> >> Hmm... Its already applied in Rafael's tree. But it doesn't mean that
> >> it can't be
> >> moved to your tree if there is a issue.
> >
> > Well, I'm dropping it.  Please merge via the Samsung tree.
> >
> 
> Oops, I missed, maybe I have no more chance to send this to upstream for 
> upcoming merge window :-(
> 
> Rafael, please take this patch with my ack in your tree, sorry for noise.
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> 
> If any problems, please kindly let me know.

Well, I suppose I can take the original patch, but then it will conflict with
your tree during merge.  Is that not a problem?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
