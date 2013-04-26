Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab3DZUmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:42:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45518 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab3DZUme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:42:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: Re: [PATCH V2] cpufreq: MAINTAINERS: Add co-maintainer
Date: Fri, 26 Apr 2013 22:50:41 +0200
Message-ID: <5352368.J64jSG7Arj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <87k3npz0yb.fsf@linaro.org>
References: <d62f23f626eaf334236cb9694c83ee4619460b76.1366980696.git.viresh.kumar@linaro.org> <87k3npz0yb.fsf@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 26, 2013 09:55:08 AM Kevin Hilman wrote:
> Viresh Kumar <viresh.kumar@linaro.org> writes:
> 
> > With prior discussions (Over private emails) with current Maintainer of cpufreq
> > framework (Rafael), I am adding myself as a co-maintainer of cpufreq framework.
> >
> > This would mostly be for cpufreq core and ARM drivers but not restricted to
> > them.
> >
> > This also adds path of the git tree where cpufreq patches are pulled in.
> >
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> As long as you continue to make an effort to ensure that the
> platform-specific drivers have proper acks from platform-specific folks.
> For ARM, this means not the arm-soc maintainers but the ARM subarch
> maintianers.
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>

OK, applied.

Thanks,
Rafael


> > ---
> > V1->V2:
> > - Added path of git tree too.
> > - Cc'd ARM SoC Maintainers.
> >
> >  MAINTAINERS | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 68d376e..cbed63c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2211,9 +2211,11 @@ F:	drivers/net/ethernet/ti/cpmac.c
> >  
> >  CPU FREQUENCY DRIVERS
> >  M:	Rafael J. Wysocki <rjw@sisk.pl>
> > +M:	Viresh Kumar <viresh.kumar@linaro.org>
> >  L:	cpufreq@vger.kernel.org
> >  L:	linux-pm@vger.kernel.org
> >  S:	Maintained
> > +T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> >  F:	drivers/cpufreq/
> >  F:	include/linux/cpufreq.h
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
