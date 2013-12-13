Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3LMGqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:46:36 -0500
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:27631
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab3LMGqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:46:33 -0500
X-Greylist: delayed 888 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Dec 2013 01:46:33 EST
From: "Hong-Xing.Zhu@freescale.com" <Hong-Xing.Zhu@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "Jason Cooper" <jason@lakedaemon.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>
Subject: RE: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
Thread-Topic: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
Thread-Index: AQHO9p9/x7qPVBPjeUW4tzOsb7h28ZpQIoWAgADh0ACAAJnHAIAADYFA
Date: Fri, 13 Dec 2013 06:31:42 +0000
Message-ID: <e0528b75cb62462eba9cdc9ff903814b@BLUPR03MB136.namprd03.prod.outlook.com>
References: <20131211183237.GI4699@google.com>
 <20131212070045.GO18380@S2101-09.ap.freescale.net>
 <CAErSpo5O1nSkKmWfHGGZiuVdvRxFjNNDS-8BWKFhnCgwVSdr8A@mail.gmail.com>
 <20131213053922.GP18380@S2101-09.ap.freescale.net>
In-Reply-To: <20131213053922.GP18380@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51914003)(51704005)(24454002)(377454003)(189002)(199002)(164054003)(13464003)(87266001)(65816001)(81342001)(74502001)(87936001)(46102001)(74706001)(83072002)(74876001)(51856001)(69226001)(2656002)(76796001)(76576001)(76786001)(90146001)(56816005)(47446002)(79102001)(63696002)(66066001)(80022001)(81542001)(56776001)(54356001)(53806001)(76482001)(81816001)(81686001)(74662001)(59766001)(77982001)(85852003)(74366001)(77096001)(31966008)(74316001)(4396001)(85806002)(54316002)(80976001)(85306002)(83322001)(19580395003)(19580405001)(49866001)(33646001)(47736001)(50986001)(47976001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB136;H:BLUPR03MB136.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn:


> -----Original Message-----
> From: Shawn Guo [mailto:shawn.guo@linaro.org]
> Sent: Friday, December 13, 2013 1:39 PM
> To: Bjorn Helgaas
> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm; linux-
> tegra@vger.kernel.org; linux-sh@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org; Jingoo Han; Jason Cooper; Thierry Reding; Simon Horman;
> Magnus Damm; Valentine Barshak; Wei Yongjun; Wei Yongjun; Kuninori Morimoto;
> Zhu Richard-R65037
> Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
> host maintainers
> 
> On Thu, Dec 12, 2013 at 01:29:00PM -0700, Bjorn Helgaas wrote:
> > On Thu, Dec 12, 2013 at 12:00 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> > > Hi Bjorn,
> > >
> > > On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> > >> +PCI DRIVER FOR IMX6
> > >> +M:   Shawn Guo <shawn.guo@linaro.org>
> > >
> > > Thanks for the nomination.  But I think a better person for this
> > > position would be Richard Zhu <r65037@freescale.com> (copied).  He
> > > knows the driver and controller much better than myself, and most
> > > importantly he is the driver owner for Freescale kernel and he has
> > > the contact to Freescale PCIe hardware people.
> >
> > Richard, are you OK with being listed here?
> 
> Richard is on leave these two days.  Hope he will be back to online soon.
[Richard] I went to hospital in the past two days.
Thanks, I'm ok with being listed here.

> 
> > Shawn, do you want to be
> > listed here in addition, if only to make sure you're copied on changes
> > to pci-imx6.c?
> 
> Okay, thanks, Bjorn.
> 
> Shawn

Best Regards
Richard Zhu

