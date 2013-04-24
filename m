Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3DXPNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:13:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:42747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3DXPNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:13:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,542,1363158000"; 
   d="scan'208";a="300603257"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "amit.kachhap@linaro.org" <amit.kachhap@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 02/30] thermal: cpu_cooling: remove trailing white spaces
Thread-Topic: [PATCH 02/30] thermal: cpu_cooling: remove trailing white
 spaces
Thread-Index: AQHOO472Ch1hamsIGk+e4kOYxu+7K5jlfUhQgAAEeAA=
Date: Wed, 24 Apr 2013 15:13:01 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092632C9FFF@SHSMSX101.ccr.corp.intel.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
 <1366218743-20841-3-git-send-email-eduardo.valentin@ti.com>
 <744357E9AAD1214791ACBA4B0B9092632C9F6D@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B9092632C9F6D@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Zhang, Rui
> Sent: Wednesday, April 24, 2013 10:49 PM
> To: Eduardo Valentin; amit.kachhap@linaro.org
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 02/30] thermal: cpu_cooling: remove trailing white
> spaces
> 
> 
> 
> > -----Original Message-----
> > From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> > Sent: Thursday, April 18, 2013 1:12 AM
> > To: amit.kachhap@linaro.org
> > Cc: Eduardo Valentin; Zhang, Rui; linux-pm@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: [PATCH 02/30] thermal: cpu_cooling: remove trailing white
> > spaces
> > Importance: High
> >
> > Remove unnecessary white spaces.
> >
> The same comments for patch 02, 06, 09, 10, 11, 13, 18, and 30.
> 
All the other patches applied.

Thanks,
rui
> Can we run Lindent to fix all the coding style problem in one patch?
> 
> Thanks,
> rui
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: linux-pm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> > ---
> >  drivers/thermal/cpu_cooling.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/thermal/cpu_cooling.c
> > b/drivers/thermal/cpu_cooling.c index 778c43d..d0d6a0c 100644
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -131,14 +131,13 @@ static int get_property(unsigned int cpu,
> > unsigned long input,
> >  	int descend = -1;
> >  	struct cpufreq_frequency_table *table =
> >  					cpufreq_frequency_get_table(cpu);
> > -
> > +
> >  	if (!output)
> >  		return -EINVAL;
> >
> >  	if (!table)
> >  		return -EINVAL;
> >
> > -
> >  	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
> >  		/* ignore invalid entries */
> >  		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
> > --
> > 1.8.2.1.342.gfa7285d
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
