Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaEGUHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:07:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:52711 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbaEGUHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:07:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1006,1389772800"; 
   d="scan'208";a="535444372"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: [patch 31/32] ia64: Use irq_init_desc
Thread-Topic: [patch 31/32] ia64: Use irq_init_desc
Thread-Index: AQHPagtZpbZ36LbcWUak8DCuam5WLJs1i3xw
Date: Wed, 7 May 2014 20:06:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F327FC5FB@ORSMSX114.amr.corp.intel.com>
References: <20140507153622.703412101@linutronix.de>
 <20140507154340.782586778@linutronix.de>
In-Reply-To: <20140507154340.782586778@linutronix.de>
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

> Switch over to the new interface. No functional change.

ia64 parts:

Tested-by: Tony Luck <tony.luck@intel.com>
