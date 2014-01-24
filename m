Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaAXW7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:59:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:9109 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaAXW7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:59:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,715,1384329600"; 
   d="scan'208";a="444297255"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mikael Pettersson <mikpelinux@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] ia64 ski emulator patches
Thread-Topic: [PATCH 0/5] ia64 ski emulator patches
Thread-Index: AQHPGKb+JFOSUiMwU0OkA9mJI3PIepqUaQaAgAAUOJA=
Date: Fri, 24 Jan 2014 22:59:33 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31DB8B73@ORSMSX106.amr.corp.intel.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com>
 <21218.28095.779306.523187@gargle.gargle.HOWL>
In-Reply-To: <21218.28095.779306.523187@gargle.gargle.HOWL>
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

Mikulas:
>> Here I'm sending some ia64 patches to make it work in the ski emulator. 
>> This has been broken for a long time.

Thanks - There are questions from time to time on how to test ia64
for those people who do not have hardware.

Mikael:
> Thanks.  I've recently started running 3.x kernels on ia64 via ski,
> but I'm getting random kernel crashes with 3.13.  I'll give your
> patches a try shortly.

Let me know how that goes - I haven't used ski in a decade and
have quite forgotten how to set it up.

> I've written a few patches to improve other aspects of running the
> kernel on ski:
> - kernel patch to turn PAL_HALT_LIGHT into a new SSC_HALT_LIGHT,
>   and a corresponing ski patch to pause() on SSC_HALT_LIGHT; this
>   together with the fixed-frequency ITC patch allows ski to idle
>   with very low host CPU overhead when the guest kernel idles
> - kernel patch to bump the RAM size from 130MB to 2GB
>
> I'd be happy to share these patches if there's interest in them.

It seems that there are at least two of you out there - so I'm happy
to take kernel patches that make things better.  Not sure where the
ski patches go - is someone maintaining that?

-Tony
