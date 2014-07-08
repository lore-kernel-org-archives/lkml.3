Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaGHAFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:05:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:47346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbaGHAFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:05:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,622,1400050800"; 
   d="scan'208";a="539971572"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH v2 6/7] ACPI: Cleanup useless ACPI inclusion.
Thread-Topic: [PATCH v2 6/7] ACPI: Cleanup useless ACPI inclusion.
Thread-Index: AQHPmidRNGM25FUDLUqC4jV0uWnONpuVS5FQ
Date: Tue, 8 Jul 2014 00:05:01 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802633449@SHSMSX101.ccr.corp.intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
 <cover.1404706298.git.lv.zheng@intel.com>
 <cf869ff5e75e0973b065c3d3fe2fa453abcd5c97.1404706299.git.lv.zheng@intel.com>
 <2868763.c5IhTlySqm@vostro.rjw.lan>
In-Reply-To: <2868763.c5IhTlySqm@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6805IrW009688

Hi,

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Tuesday, July 08, 2014 5:24 AM
> 
> On Monday, July 07, 2014 12:17:40 PM Lv Zheng wrote:
> > The sst-haswell-dsp.c is an ACPI independent file, this patch removes
> > ACPI header files for it.
> 
> This appears to be independent of the rest of the series.  Is that correct?

Yes.
Now the <acpi/acpi_bus.h> inclusion in this file is the only one after we've cleaned up the others.

Best regards
-Lv

> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > Cc: Liam Girdwood <lgirdwood@gmail.com>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: alsa-devel@alsa-project.org
> > ---
> >  sound/soc/intel/sst-haswell-dsp.c |    3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/sound/soc/intel/sst-haswell-dsp.c b/sound/soc/intel/sst-haswell-dsp.c
> > index 535f517..ecc5057 100644
> > --- a/sound/soc/intel/sst-haswell-dsp.c
> > +++ b/sound/soc/intel/sst-haswell-dsp.c
> > @@ -28,9 +28,6 @@
> >  #include <linux/firmware.h>
> >  #include <linux/pm_runtime.h>
> >
> > -#include <linux/acpi.h>
> > -#include <acpi/acpi_bus.h>
> > -
> >  #include "sst-dsp.h"
> >  #include "sst-dsp-priv.h"
> >  #include "sst-haswell-ipc.h"
> >
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
