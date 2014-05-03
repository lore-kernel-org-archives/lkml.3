Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaECAQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 20:16:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25601 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaECAQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 20:16:16 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-95-5364354e0b4a
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Linux PM list'" <linux-pm@vger.kernel.org>
Cc: "'open list'" <linux-kernel@vger.kernel.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Len Brown'" <len.brown@intel.com>,
        "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
 <CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
In-reply-to: <CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
Subject: RE: [PATCH 1/3] PM / OPP: Add support for descending order for cpufreq
 table
Date: Sat, 03 May 2014 09:16:13 +0900
Message-id: <003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIqe0fjYa0YwQL6oKQ2dX7E8rarYwGe0UWzmmrY5+A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zQ10/05Rgg+47chYNV0MsZk3Zy2Rx
	edccNovPvUcYLc6cvsRqsfGrhwObx+I9L5k87lzbw+ax5Wo7i0ffllWMHp83yQWwRnHZpKTm
	ZJalFunbJXBlzLjRwFywXb1i2aNfTA2MG+W6GDk5JARMJF5uX8ICYYtJXLi3nq2LkYtDSGAZ
	o0TzxNmMXYwcYEVrm/VAaoQEpjNKrLvnB1Hzj1FiS3cbM0iCTUBX4tj6LawgtohAlMSEvR3s
	IEXMAhsZJX59+gY1tYFRYu+0xSwgUzkFgiWaliSCNAgLhEusWTeTCcRmEVCVuH5qNthQXgFL
	idn/rrNC2IISPybfA7uUWUBLYv3O40wQtrzE5jVvmSE+UJDYcfY1I8QRVhKd799C1YhI7Hvx
	jhGi5iW7xJruCIhdAhLfJh9igXhSVmLTAagxkhIHV9xgmcAoMQvJ5llINs9CsnkWkg0LGFlW
	MYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoTEa/8OxrsHrA8xJgOtn8gsJZqcD4z3vJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA2MHQcjO4pOeE
	n9THXW++rFslf1Kn9PTUG284SqaytjXIlX1+nbdJefHGyvoT2c1r2u+dUn5mq5tecvfMpGJl
	vhum4gHnSjbGJH97tvJX02vdCRn1h2em+QXKP1bj57hbpcUYp9UXqyVftW8xY6iCwuRdE420
	BDbt9KuMFnpezv4mcIfIB/GlSizFGYmGWsxFxYkAM85kv+0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQV0/05Rgg/NrJS0aroZYzJqyl8ni
	8q45bBafe48wWpw5fYnVYuNXDwc2j8V7XjJ53Lm2h81jy9V2Fo++LasYPT5vkgtgjWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHjRgNzwXb1imWPfjE1MG6U62Lk4JAQ
	MJFY26zXxcgJZIpJXLi3ng3EFhKYziix7p5fFyMXkP2PUWJLdxszSIJNQFfi2PotrCC2iECU
	xIS9HewgRcwCGxklfn36xgbR0cAosXfaYhaQDZwCwRJNSxJBGoQFwiXWrJvJBGKzCKhKXD81
	G2wor4ClxOx/11khbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxxqYLEjrOvGSGOsJLofP8W
	qkZEYt+Ld4wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZG
	cDp4Jr2DcVWDxSFGAQ5GJR5ehbvJwUKsiWXFlbmHGCU4mJVEeFk0U4KFeFMSK6tSi/Lji0pz
	UosPMSYDfTqRWUo0OR+YqvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoE
	s4WJg1OqgVH33P/qh80zVD+I6u3Le8Lq/eL45OwNX7KX7SuMTWfv8rvTZLN7Vc3jpzbP7Twu
	/XOa//BeJM+xHeXNlkxcpRdfql5c7pjAXsau8tbvboNOivDXxoq65zzh9zk3P/D5sH/ZLDH1
	6/GHHV7f/yIRJh4S63Ls0MdfR5+5izM+ZLgt2vTk6sKiZY1KLMUZiYZazEXFiQCkreduSwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Viresh Kumar
Your reply is so fast like Usain Bolt.

> So, create three flags:
> OPP_TABLE_ORDER_ASCENDING              0
> OPP_TABLE_ORDER_DESCENDING            1
> OPP_TABLE_ORDER_ORIGINAL                  2 (And use this for your case.)

-> Actually, I want to use OPP_TABLE_ORDER_DESCENDING.(Not
OPP_TABLE_ORDER_ORIGINAL.)
I think that it is enough to support both descending and ascending ordering
only.
The meaning of "ORIGIANL" Amit, said, when he(and I) writes a frequency in
dts file with ordering(Ascending or Descending). He(and I) want the
frequency to be register according to ordering.(Ascending or Descending).

I concerned that if we use ORIGINAL ordering, opp_find_freq_ceil/foor can be
broken.
(example, 1GH - 500MH - 800MHz - 200MHz - 600MHz)

Thanks~

Best Regars

> -----Original Message-----
> From: viresh.linux@gmail.com [mailto:viresh.linux@gmail.com] On Behalf Of
> Viresh Kumar
> Sent: Wednesday, April 30, 2014 5:25 PM
> To: Jonghwan Choi; Linux PM list
> Cc: open list; Rafael J. Wysocki; Len Brown; Amit Daniel Kachhap
> Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
> cpufreq table
> 
> Hi,
> 
> This isn't a very big patchset and this patch is very much required to
> understand other patches and so please cc all people from other list here
> as well..
> 
> On Wed, Apr 30, 2014 at 11:58 AM, Jonghwan Choi <jhbird.choi@samsung.com>
> wrote:
> > In the frequency table dts file, the frequencies are arranged in
> 
> Improve your logs a bit. Which dts file are you talking about here ?
> How would anybody know that you are talking about exynos here?
> 
> Also, you shouldn't mention that here, just tell the kind of requirement
> platforms may have. i.e. people may want to keep the opp list in the same
> order in which it came from DT.
> 
> > descending order which maps 1 to 1 with other frequency parameter to
> > be calculated and programmed in some registers.
> > But the OPP library works by generating the frequencies in ascending
> > order which breaks the above logic.
> > So added OPP_TABLE_ORDER_DESCEND flag to consider descending order.
> 
> So, create three flags:
> OPP_TABLE_ORDER_ASCENDING              0
> OPP_TABLE_ORDER_DESCENDING            1
> OPP_TABLE_ORDER_ORIGINAL                  2 (And use this for your case.)
> 
> > Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> > ---
> >  drivers/base/power/opp.c |   17 ++++++++++++++++-
> >  include/linux/pm_opp.h   |    7 +++++--
> >  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> You are changing prototype of a function and so all other files which are
> using this routine will break after this patch and we can't afford it as
> we want git bisect to work properly.
> 
> So, fix all platforms here in this patch only, i.e. part of 2/3 and
> complete 3/3 should have been merged into this one.
> 
> > diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c index
> > 2553867..ec7d553 100644
> > --- a/drivers/base/power/opp.c
> > +++ b/drivers/base/power/opp.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/cpufreq.h>
> >  #include <linux/device.h>
> >  #include <linux/list.h>
> > +#include <linux/list_sort.h>
> >  #include <linux/rculist.h>
> >  #include <linux/rcupdate.h>
> >  #include <linux/pm_opp.h>
> > @@ -597,10 +598,21 @@ int dev_pm_opp_disable(struct device *dev,
> > unsigned long freq)  EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
> >
> >  #ifdef CONFIG_CPU_FREQ
> > +
> > +static int opp_descend_cmp(void *priv, struct list_head *a,
> > +                                        struct list_head *b) {
> > +        struct dev_pm_opp *ra = list_entry(a, struct dev_pm_opp, node);
> > +        struct dev_pm_opp *rb = list_entry(b, struct dev_pm_opp,
> > +node);
> > +
> > +        return rb->rate - ra->rate;
> > +}
> > +
> >  /**
> >   * dev_pm_opp_init_cpufreq_table() - create a cpufreq table for a
> device
> >   * @dev:       device for which we do this operation
> >   * @table:     Cpufreq table returned back to caller
> > + * @flags:     OPP_TABLE_ORDER_DESCEND or zero
> >   *
> >   * Generate a cpufreq table for a provided device- this assumes that
> the
> >   * opp list is already initialized and ready for usage.
> > @@ -622,7 +634,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
> >   * or in contexts where mutex locking cannot be used.
> >   */
> >  int dev_pm_opp_init_cpufreq_table(struct device *dev,
> > -                           struct cpufreq_frequency_table **table)
> > +               struct cpufreq_frequency_table **table, unsigned char
> > + flags)
> 
> You are targeting the wrong routine. Fix of_init_opp_table() instead and
> things would work automatically then..
> 
> And please don't change prototype of dev_pm_opp_add() for now and just
> define __dev_pm_opp_add() which will be called from
> dev_pm_opp_add() and of_init_opp_table() with 'int order' parameter.

