Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3LNW1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 17:27:34 -0500
Received: from [207.46.163.184] ([207.46.163.184]:23195 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754041Ab3LNW1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 17:27:33 -0500
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Dec 2013 17:27:33 EST
From: KY Srinivasan <kys@microsoft.com>
To: Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH] drivers: hv: Mark the function hv_synic_free_cpu() as
 static in hv.c
Thread-Topic: [PATCH] drivers: hv: Mark the function hv_synic_free_cpu() as
 static in hv.c
Thread-Index: AQHO+NCgmXn0FiHkj0eeBToChb3mAppULIOAgAAUiOA=
Date: Sat, 14 Dec 2013 22:11:20 +0000
Message-ID: <00146d38076644c3ba24effa8d9f8ee5@BY2PR03MB299.namprd03.prod.outlook.com>
References: <20131214133006.GA8773@rashika> <20131214205717.GR17601@leaf>
In-Reply-To: <20131214205717.GR17601@leaf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:ed4b:ad41:42e9:d231]
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(13464003)(24454002)(51704005)(199002)(189002)(377454003)(54316002)(80022001)(65816001)(76786001)(76796001)(76576001)(80976001)(79102001)(63696002)(59766001)(77982001)(56776001)(81686001)(83322001)(19580405001)(19580395003)(74316001)(74366001)(76482001)(54356001)(53806001)(81342001)(81542001)(69226001)(56816005)(90146001)(4396001)(50986001)(47976001)(47736001)(49866001)(31966008)(74662001)(47446002)(74502001)(51856001)(46102001)(83072002)(85852003)(87936001)(74706001)(81816001)(87266001)(85306002)(74876001)(2656002)(33646001)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:2601:8:9b00:402:ed4b:ad41:42e9:d231;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBEMRhPC017698



> -----Original Message-----
> From: Josh Triplett [mailto:josh@joshtriplett.org]
> Sent: Saturday, December 14, 2013 12:57 PM
> To: Rashika Kheria
> Cc: linux-kernel@vger.kernel.org; KY Srinivasan; Haiyang Zhang;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH] drivers: hv: Mark the function hv_synic_free_cpu() as static
> in hv.c
> 
> On Sat, Dec 14, 2013 at 07:00:06PM +0530, Rashika Kheria wrote:
> > This patch marks the function hv_synic_free_cpu() as static in hv.c
> > because it is not used outside this file.
> >
> > Thus, it also eliminates the following warning in hv.c:
> > drivers/hv/hv.c:304:6: warning: no previous prototype for â€˜hv_synic_free_cpuâ€™
> [-Wmissing-prototypes]
> >
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Thank you.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> >  drivers/hv/hv.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> > index f0c5e07..bcb4950 100644
> > --- a/drivers/hv/hv.c
> > +++ b/drivers/hv/hv.c
> > @@ -301,7 +301,7 @@ err:
> >  	return -ENOMEM;
> >  }
> >
> > -void hv_synic_free_cpu(int cpu)
> > +static void hv_synic_free_cpu(int cpu)
> >  {
> >  	kfree(hv_context.event_dpc[cpu]);
> >  	if (hv_context.synic_event_page[cpu])
> > --
> > 1.7.9.5
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
