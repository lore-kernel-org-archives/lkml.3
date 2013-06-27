Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3F0HfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:35:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:9893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3F0He6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:34:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="356498217"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: manual merge of the wireless-next tree with the
 net-next tree
Thread-Topic: linux-next: manual merge of the wireless-next tree with the
 net-next tree
Thread-Index: AQHOcu4vi1yOZaYjwkaHQjmsW3gEc5lJK3LQ
Date: Thu, 27 Jun 2013 07:34:55 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61AA36266@IRSMSX102.ger.corp.intel.com>
References: <20130627142318.78f78fdbb49c927a7cb7bc50@canb.auug.org.au>
In-Reply-To: <20130627142318.78f78fdbb49c927a7cb7bc50@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Today's linux-next merge of the wireless-next tree got a conflict in
> net/wireless/nl80211.c between merge commits from the net-next tree and
> commit 86e8cf98de3e ("nl80211: use small state buffer for wiphy_dump")
> from the wireless-next tree.

Looks good, yes.

> I think I fixed it up (see below, please check) and can carry the fix as
> necessary (no action is required).  I think that my fix means that that commit
> 86e8cf98de3e is missing the extra "rtnl_unlock();", right?

*sigh*, yes, I clearly have issues with the locking in this function, second time here. Sorry about that, I'll put in a fix.

johannes

-- 

Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

