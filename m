Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBYNe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:34:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:61379 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaBYNez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:34:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="487747603"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 2/3] x86, mpx: hook #BR exception handler to allocate
 bound tables
Thread-Topic: [PATCH v5 2/3] x86, mpx: hook #BR exception handler to
 allocate bound tables
Thread-Index: AQHPMF7sO2qtZ+ouhUGFbjVRemsqiZrEJJwAgAAGpYCAAdBW0A==
Date: Tue, 25 Feb 2014 13:34:24 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE0151FC9E@SHSMSX102.ccr.corp.intel.com>
References: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com>
 <1393162071-23995-3-git-send-email-qiaowei.ren@intel.com>
 <530B8112.5080400@intel.com> <530B86A5.6060100@zytor.com>
In-Reply-To: <530B86A5.6060100@zytor.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Tuesday, February 25, 2014 1:52 AM
> To: Hansen, Dave; Ren, Qiaowei; Thomas Gleixner; Ingo Molnar
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v5 2/3] x86, mpx: hook #BR exception handler to allocate
> bound tables
> 
> On 02/24/2014 09:27 AM, Dave Hansen wrote:
> >
> > Can you talk a little bit about what the design is here?  Why does the
> > kernel have to do the allocation of the virtual address space?  Does
> > it really need to MAP_POPULATE?  bt_size looks like 4MB, and that's an
> > awful lot of memory to eat up at once.  Shouldn't we just let the
> > kernel demand-fault this like everything else?
> >
> 
> MAP_POPULATE definitely seems like the wrong thing.
> 
Oh. This option should be removed.

Thanks,
Qiaowei
