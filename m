Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab3LLFHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:07:25 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:58334 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117Ab3LLFHU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:07:20 -0500
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Jingoo Han <jg1.han@samsung.com>, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Jason Cooper'" <jason@lakedaemon.net>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Simon Horman'" <horms@verge.net.au>,
        "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Valentine Barshak'" <valentine.barshak@cogentembedded.com>,
        "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Kuninori Morimoto'" <kuninori.morimoto.gx@renesas.com>,
        Pratyush ANAND <pratyush.anand@st.com>
Date: Thu, 12 Dec 2013 13:06:16 +0800
Subject: RE: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
Thread-Topic: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI
 host maintainers
Thread-Index: Ac72oOLDM71EYw9eQ8OWHSuWMlHqsQAHjYAAAA4hpeA=
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB66189F95F642F@EAPEX1MAIL1.st.com>
References: <20131211183237.GI4699@google.com>
 <20131211184321.GJ4699@google.com>
 <000f01cef6bf$cd0fe340$672fa9c0$%han@samsung.com>
In-Reply-To: <000f01cef6bf$cd0fe340$672fa9c0$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jingoo Han [mailto:jg1.han@samsung.com]
> Sent: Thursday, December 12, 2013 3:55 AM
> To: 'Bjorn Helgaas'; linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linux-tegra@vger.kernel.org; linux-sh@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org; 'Shawn Guo'; 'Jason Cooper'; 'Thierry Reding'; 'Simon
> Horman'; 'Magnus Damm'; 'Valentine Barshak'; 'Wei Yongjun'; 'Wei Yongjun';
> 'Kuninori Morimoto'; Mohit KUMAR DCG; Pratyush ANAND; 'Jingoo Han'
> Subject: Re: [PATCH] MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car
> PCI host maintainers
> 
> On Thursday, December 12, 2013 3:43 AM, Bjorn Helgaas wrote:
> > On Wed, Dec 11, 2013 at 11:32:37AM -0700, Bjorn Helgaas wrote:
> > > If this looks reasonable, I'll merge it via the PCI tree for v3.13.
> >
> > And I see Mohit's patch [1] to update the DesignWare entry:
> >
> > +PCIE DRIVER FOR SYNOPSIS DESIGNWARE CONTROLLER
> > +M:	Mohit Kumar <mohit.kumar@st.com>
> > +M:	Jingoo Han <jg1.han@samsung.com>
> > +L:	linux-pci@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/pci/host/pcie-designware.c
> >
> > I can fold in that update too if Jingoo acks it.
> >
> > [1] http://patchwork.ozlabs.org/patch/299905/
> 
> Hi Bjorn,
> 
> I agree with this. :-)
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> 
- Thanks Bjorn and Jingoo. I will remove this patch from my v2 patches.

Regards
Mohit
