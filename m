Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaBSEJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:09:42 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54623 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbaBSEJk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:09:40 -0500
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Date: Wed, 19 Feb 2014 12:09:00 +0800
Subject: RE: [PATCH V5 4/8] phy: st-miphy-40lp: Add skeleton driver
Thread-Topic: [PATCH V5 4/8] phy: st-miphy-40lp: Add skeleton driver
Thread-Index: Ac8nNxChuHF81Y+JRBCV5ollScfbmAAcOi5wAV/3SvA=
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB66189FD40D477@EAPEX1MAIL1.st.com>
References: <cover.1391871170.git.pratyush.anand@st.com>
 <201402101654.22187.arnd@arndb.de>
 <2CC2A0A4A178534D93D5159BF3BCB66189FD2CAA9B@EAPEX1MAIL1.st.com>
 <10315753.nkNxr0yDnp@wuerfel>
 <2CC2A0A4A178534D93D5159BF3BCB66189FD2CAD14@EAPEX1MAIL1.st.com>
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB66189FD2CAD14@EAPEX1MAIL1.st.com>
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

Hello Arnd,

> -----Original Message-----
> From: Mohit KUMAR [mailto:mohit.kumar@st.com]
> Sent: Wednesday, February 12, 2014 10:22 AM
> To: Arnd Bergmann
> Cc: Pratyush ANAND; Kishon Vijay Abraham I; spear-devel; linux-arm-
> kernel@lists.infradead.org; devicetree@vger.kernel.org; linux-
> kernel@vger.kernel.org; Lee Jones
> Subject: RE: [PATCH V5 4/8] phy: st-miphy-40lp: Add skeleton driver
> 
> Hello Arnd,
> 
> > -----Original Message-----
> > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > Sent: Tuesday, February 11, 2014 8:09 PM
> > To: Mohit KUMAR DCG
> > Cc: Pratyush ANAND; Kishon Vijay Abraham I; spear-devel; linux-arm-
> > kernel@lists.infradead.org; devicetree@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Lee Jones
> > Subject: Re: [PATCH V5 4/8] phy: st-miphy-40lp: Add skeleton driver
> >
> > On Tuesday 11 February 2014 11:57:46 Mohit KUMAR DCG wrote:
> > >
> > > > Maybe mention that this phy is used inside the spear13xx SoC here
> > > > rather than a standalone phy.
> > >
> > > - Yes, for spear13xx its used internally. Do you think that it
> > > requires to be mentioned here?
> > > We have few prototype boards that uses this as external phy.
> >
> > [adding Lee since he mentioned working on a similar part]
> >
> > I'm a bit confused. Is it actually the same IP block that can be used
> > internally as part of a SoC and as a standalone chip?
> >
> > Since some of the settings of the PHY are controlled through the misc
> > register in case of spear13xx, I assume that part is different on the
> > standalone version. How do you actually select the mode in that case?
> >
> > It would certainly be helpful to explain this somewhere, and the
> > binding might not be the worst place for this.
> >
> > On a related note, the driver in its current shape looks a bit silly
> > since it doesn't contain any of the miphy specific code but only the
> > SoC specific parts (as I suggested you do, so I'm not blaming you :-))
> > and a multiplexer that switches between the two possible
> implementations.
> 
> - yes, thats what we were explaining earlier. If it is integrated into some SoC
> Then there are some soc specific configurations. Actual phy reg settings could
> also vary for the different SoCs for the best tuning.
> 
> However we agreed to your idea as miphy40lp register definitions would
> remain same across the SoCs.
> 
> >
> > What is your plan for the future, do you intend to add the actual
> > miphy code soon, or is that something you just want to leave as an
> > option for the future but have no specific plans to do right now? If
> > not, the driver would probably look nicer if it were split into two
> > separate implementations, one for each spear13xx SoC and with a separate
> set of phy_ops but no multiplexer.
> 
> Do you want  it to split the code into two different files like phy-
> miphyspear1310.c and phy-miphyspear1340.c ?

- Waiting for your final say about splitting into two different files or any
 other comment for the  patch series?

Thanks
Mohit
 
