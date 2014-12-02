Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbaLBTcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:32:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:49076 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbaLBTcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:32:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,502,1413270000"; 
   d="scan'208";a="641529345"
From: "Luck, Tony" <tony.luck@intel.com>
To: Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: Final per cpu consistency patch for -next or late in 3.19 merge
 period
Thread-Topic: Final per cpu consistency patch for -next or late in 3.19
 merge period
Thread-Index: AQHQDlZFEOVeaR8U6U2qrgzHGM/eJZx8rshA
Date: Tue, 2 Dec 2014 19:27:03 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32959CA8@ORSMSX114.amr.corp.intel.com>
References: <alpine.DEB.2.11.1411281229350.11435@gentwo.org>
 <20141202164024.GA10918@htj.dyndns.org>
 <alpine.DEB.2.11.1412021049580.13039@gentwo.org>
 <20141202171102.GC10918@htj.dyndns.org>
 <alpine.DEB.2.11.1412021131350.19228@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1412021131350.19228@gentwo.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Christoph Lameter <cl@linux.com>
> Subject: ia64: Update comment that references __get_cpu_var
>
> __get_cpu_var was removed. Update the comments.

Applied.  Will send to Linus towards the end of the merge window

Thanks

-Tony
