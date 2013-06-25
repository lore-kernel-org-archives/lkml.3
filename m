Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3FYQb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:31:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:39466 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3FYQbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:31:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="359365368"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Chen Gong <gong.chen@linux.intel.com>
CC: "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86/MCE: Update MCE severity condition check
Thread-Topic: [PATCH] x86/MCE: Update MCE severity condition check
Thread-Index: AQHObZf4dVtHLM6ankO4NgcMDQSyUJlGddGAgAAxdHA=
Date: Tue, 25 Jun 2013 16:31:23 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C53805@ORSMSX106.amr.corp.intel.com>
References: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com>
 <20130625063257.GA2274@naverao1-tp.in.ibm.com>
In-Reply-To: <20130625063257.GA2274@naverao1-tp.in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The SDM talks about "non-affected" logical processors, but perhaps we
> can call this an "unaffected" thread?

"unaffected" sounds a bit more natural (but close enough to the wording in
the SDM that people should see the connection).

-Tony
