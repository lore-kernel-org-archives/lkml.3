Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3LRV7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:59:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:52053 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab3LRV7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:59:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,509,1384329600"; 
   d="scan'208";a="452256438"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mark Salter <msalter@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH v2 00/10] Kconfig: cleanup SERIO_I8042 dependencies
Thread-Topic: [PATCH v2 00/10] Kconfig: cleanup SERIO_I8042 dependencies
Thread-Index: AQHO+z/OuxcCzhfNTESZVWf9Hu2Bc5pagiFA
Date: Wed, 18 Dec 2013 21:59:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D8CDD5@ORSMSX106.amr.corp.intel.com>
References: <1387295333-24684-1-git-send-email-msalter@redhat.com>
In-Reply-To: <1387295333-24684-1-git-send-email-msalter@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is v2 of the patch series. Changes from version 1:
>
>  o Added acks. arm, ia64, and sh are only ones without acks.

ia64 bits look OK

Acked-by: Tony Luck <tony.luck@intel.com>
