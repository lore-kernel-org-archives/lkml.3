Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152Ab3DEL2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:28:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51841 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab3DEL2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:28:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Ben Dooks <ben-linux@fluff.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
Date: Fri, 05 Apr 2013 13:36:29 +0200
Message-ID: <1769336.FkfMpuXqqb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokk1Q+0gRpeW=ts0a8D+rGAUpHu62X+7ejdpfom_B6FYA@mail.gmail.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org> <2a5901ce31c9$95160980$bf421c80$%kim@samsung.com> <CAKohpokk1Q+0gRpeW=ts0a8D+rGAUpHu62X+7ejdpfom_B6FYA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 05, 2013 12:36:34 PM Viresh Kumar wrote:
> On 5 April 2013 12:18, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Basically, this moving looks good to me, but should be re-worked based on
> > for-next of samsung tree because this touches too many samsung stuff so this
> > should be sent to upstream via samsung tree.
> 
> Hmm... Its already applied in Rafael's tree. But it doesn't mean that
> it can't be
> moved to your tree if there is a issue.

Well, I'm dropping it.  Please merge via the Samsung tree.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
