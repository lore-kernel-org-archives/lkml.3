Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3LTXHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:07:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:6038 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab3LTXHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:07:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,524,1384329600"; 
   d="scan'208";a="447845522"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andi Kleen <ak@linux.intel.com>, Prarit Bhargava <prarit@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Morgan, Janet" <janet.morgan@intel.com>,
        "ruiv.wang@gmail.com" <ruiv.wang@gmail.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>
Subject: RE: [PATCH] x86: Add check for number of available vectors before
 CPU down [v3]
Thread-Topic: [PATCH] x86: Add check for number of available vectors before
 CPU down [v3]
Thread-Index: AQHO/aIchQHZ253OjUuE6k5WgJoggZpeOEEA//9625A=
Date: Fri, 20 Dec 2013 23:06:59 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D8F0E9@ORSMSX106.amr.corp.intel.com>
References: <1387554609-9823-1-git-send-email-prarit@redhat.com>
 <20131220225624.GD22695@tassilo.jf.intel.com>
In-Reply-To: <20131220225624.GD22695@tassilo.jf.intel.com>
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

> I haven't double checked, but I'm assuming the hot plug locks are held
> while you are doing this.

I dug into that when looking at v2 - the whole thing is under "stop_machine()"
so locking was not an issue.

Reviewed-by: Tony Luck <tony.luck@intel.com>

-Tony
