Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3IKGud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:50:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:26648 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab3IKGuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:50:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,882,1371106800"; 
   d="scan'208";a="358794987"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [199/251] genetlink: fix family dump race
Thread-Topic: [199/251] genetlink: fix family dump race
Thread-Index: AQHOrqt5r+EF14TrnEyVL6LQnOb565nAGMpA
Date: Wed, 11 Sep 2013 06:50:10 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61AABAF33@IRSMSX102.ger.corp.intel.com>
References: <20130911042707.738353451@goodmis.org>
 <20130911042925.297207769@goodmis.org>
In-Reply-To: <20130911042925.297207769@goodmis.org>
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

> 3.6.11.9-rc1 stable review patch.
> If anyone has any objections, please let me know.

Yes, this patch is broken and we reverted it upstream. 

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

