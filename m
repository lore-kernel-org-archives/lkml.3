Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaIZMMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:12:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:4128 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbaIZMMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="605796405"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        David Miller <davem@davemloft.net>
CC: "rayagond@vayavyalabs.com" <rayagond@vayavyalabs.com>,
        "vbridgers2013@gmail.com" <vbridgers2013@gmail.com>,
        "wens@csie.org" <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "tobias.johannes.klausmann@mni.thm.de" 
	<tobias.johannes.klausmann@mni.thm.de>
Subject: RE: [PATCH] net: stmmac: fix stmmac_pci_probe failed when
 CONFIG_HAVE_CLK is selected
Thread-Topic: [PATCH] net: stmmac: fix stmmac_pci_probe failed when
 CONFIG_HAVE_CLK is selected
Thread-Index: AQHP1pHhFepY2RdQhkeVpgdU2wwwn5wN2aRw///dKYCAAIehAIABCo0AgADI8ZCAAr8yAIAAh4KQ
Date: Fri, 26 Sep 2014 12:12:05 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B7F4A0D@PGSMSX102.gar.corp.intel.com>
References: <1411043650-31712-1-git-send-email-hock.leong.kweh@intel.com>
 <20140922.141921.577008114679288180.davem@davemloft.net>
 <F54AEECA5E2B9541821D670476DAE19C2B7EAE19@PGSMSX102.gar.corp.intel.com>
 <54210EC1.9070507@st.com>
 <F54AEECA5E2B9541821D670476DAE19C2B7EAF23@PGSMSX102.gar.corp.intel.com>
 <54226020.50008@st.com>
 <F54AEECA5E2B9541821D670476DAE19C2B7EB35E@PGSMSX102.gar.corp.intel.com>
 <54255692.8020402@st.com>
In-Reply-To: <54255692.8020402@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Giuseppe CAVALLARO [mailto:peppe.cavallaro@st.com]
> Sent: Friday, September 26, 2014 8:06 PM
> > > From: Giuseppe CAVALLARO [mailto:peppe.cavallaro@st.com]
> > > Sent: Wednesday, September 24, 2014 2:10 PM
> 
> I just meant that if no clock is passed then the probe doesn't fail and we can
> keep a dev_warn. Pls surround the code with a comment and repost the
> patch. Let me know and sorry for the delay on replying.
> 
> peppe
> 

Now I got you. Okay, will do that and send out the V2 patch. Thanks.
