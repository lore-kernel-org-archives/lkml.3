Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaBLEIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:08:05 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:49176 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbaBLEID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:08:03 -0500
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, "arnd@arndb.de" <arnd@arndb.de>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Feb 2014 12:07:28 +0800
Subject: RE: [PATCH V6 07/12] phy: st-miphy-40lp: Add SPEAr1310 and
 SPEAr1340 PCIe phy support
Thread-Topic: [PATCH V6 07/12] phy: st-miphy-40lp: Add SPEAr1310 and
 SPEAr1340 PCIe phy support
Thread-Index: Ac8nIaxj2wdhtf/bTL2uAZZKtjG4zQAhfhSQ
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB66189FD2CACEA@EAPEX1MAIL1.st.com>
References: <cover.1392109054.git.mohit.kumar@st.com>
 <f84ed875ae7a356a8056f4645a4d1e59c665c972.1392109054.git.mohit.kumar@st.com>
 <52FA122A.1010900@ti.com>
In-Reply-To: <52FA122A.1010900@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1C48nhg014985

Hello Kishon,

> -----Original Message-----
> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Tuesday, February 11, 2014 5:36 PM
> To: Mohit KUMAR DCG; arnd@arndb.de
> Cc: Pratyush ANAND; Viresh Kumar; spear-devel; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V6 07/12] phy: st-miphy-40lp: Add SPEAr1310 and
> SPEAr1340 PCIe phy support
> 
> On Tuesday 11 February 2014 03:00 PM, Mohit Kumar wrote:
> > From: Pratyush Anand <pratyush.anand@st.com>
> >
> > SPEAr1310 and SPEAr1340 uses miphy40lp phy for PCIe. This driver adds
> > support for the same.
> 
> What's up with SATA support for SPEAr1310? Do you have plans of adding it
> soon?
> >

- yes we will be doing it after this series is finalized.

[...]
> > +
> > +	regmap_update_bits(priv->misc, SPEAR1310_PCIE_MIPHY_CFG_1,
> > +			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK,
> > +			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE);
> > +
> > +	switch (priv->id) {
> 
> 'id' should be made as optional dt property since it's not used for 1340 no?
> 
- ok
Thanks
Mohit
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
