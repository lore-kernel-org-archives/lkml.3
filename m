Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaH2B2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:28:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:52297 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaH2B2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:28:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378453658"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Rayagond K <rayagond@vayavyalabs.com>
Subject: RE: [PATCH 0/4] net: stmmac: Enable Intel Quark SoC X1000 Ethernet
 support
Thread-Topic: [PATCH 0/4] net: stmmac: Enable Intel Quark SoC X1000 Ethernet
 support
Thread-Index: AQHPwcriov0aluuOkUqC4/B/pAR9F5vj4e4AgALqYlA=
Date: Fri, 29 Aug 2014 01:28:14 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B6E7189@PGSMSX102.gar.corp.intel.com>
References: <cover.1409123378.git.hock.leong.kweh@intel.com>
 <53FDD4A4.5020603@st.com>
In-Reply-To: <53FDD4A4.5020603@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Giuseppe CAVALLARO [mailto:peppe.cavallaro@st.com]
> Sent: Wednesday, August 27, 2014 8:53 PM
> To: Kweh, Hock Leong; David S. Miller
> Cc: netdev@vger.kernel.org; LKML; Ong, Boon Leong; Rayagond K
> Subject: Re: [PATCH 0/4] net: stmmac: Enable Intel Quark SoC X1000 Ethernet
> support
> 
> On 8/27/2014 12:32 PM, Kweh Hock Leong wrote:
> 
> hello and thx for these patches that at first glance look ok to me.
> Just some minor remark, in the stmmac I try to align the function parameters
> with the open parenthesis (devm_kzalloc in your case in not aligned).
> Added on copy also Rayagond he tested PCI. I cannot do any test because I
> have no PCI cards.
> 
> peppe
> 

Hi, noted and will update that in the v2 patch. Looking forward to get more feedback
before sending out the second version. Thanks.


Regards,
Wilson
