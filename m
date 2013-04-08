Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936539Ab3DHKi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:38:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54047 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934557Ab3DHKi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:38:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Viresh Kumar'" <viresh.kumar@linaro.org>, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
Date: Mon, 08 Apr 2013 12:46:38 +0200
Message-ID: <2166815.0SZ6SYhSDN@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2ccd01ce3439$911b51b0$b351f510$%kim@samsung.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org> <1769336.FkfMpuXqqb@vostro.rjw.lan> <2ccd01ce3439$911b51b0$b351f510$%kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 08, 2013 06:15:09 PM Kukjin Kim wrote:
> Rafael J. Wysocki wrote:
> > 
> > On Friday, April 05, 2013 12:36:34 PM Viresh Kumar wrote:
> > > On 5 April 2013 12:18, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > > > Basically, this moving looks good to me, but should be re-worked based
> > on
> > > > for-next of samsung tree because this touches too many samsung stuff
> > so this
> > > > should be sent to upstream via samsung tree.
> > >
> > > Hmm... Its already applied in Rafael's tree. But it doesn't mean that
> > > it can't be
> > > moved to your tree if there is a issue.
> > 
> > Well, I'm dropping it.  Please merge via the Samsung tree.
> > 
> OK, I will.
> 
> I got patch file from Viresh, and there is a sign from Rafael,
> but it should be ack. So Rafael, let me use your ack on this patch when
> I apply. If any problems, please let me know.

Since it was signed-off by me before, you can assume it's been ACKed as well.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
