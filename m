Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3GWBi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:38:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:42386 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab3GWBiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:38:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,723,1367996400"; 
   d="scan'208";a="374832327"
From: "Brown, Len" <len.brown@intel.com>
To: Tang Chen <tangchen@cn.fujitsu.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] x86, acpi: Fix wrong checking condition in
 acpi_register_lapic().
Thread-Topic: [PATCH 1/1] x86, acpi: Fix wrong checking condition in
 acpi_register_lapic().
Thread-Index: AQHOh0Ub2rm/m+oOB0GzuH1vXqb5lJlxe/Lg
Date: Tue, 23 Jul 2013 01:38:14 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C9484119183C@FMSMSX106.amr.corp.intel.com>
References: <1374543541-4451-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1374543541-4451-1-git-send-email-tangchen@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Len Brown <len.brown@intel.com>

