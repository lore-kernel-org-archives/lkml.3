Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLRSBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:01:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:22345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaLRSBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:01:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,602,1413270000"; 
   d="scan'208";a="656542771"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Williamson, Glenn P" <glenn.p.williamson@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
Thread-Topic: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
Thread-Index: AQHQGkMtbeFTaP8A+kS0cHcWdKFM9JyWIN8A//+Ac4A=
Date: Thu, 18 Dec 2014 17:51:19 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A6C1D8F@ORSMSX106.amr.corp.intel.com>
References: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com>
 <54930E14.30800@zytor.com>
In-Reply-To: <54930E14.30800@zytor.com>
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

> Sent: Thursday, December 18, 2014 9:26 AM
> To: Yu, Fenghua; Thomas Gleixner; H. Peter Anvin; Ingo Molnar; Williamson,
> Glenn P
> Cc: linux-kernel; x86
> Subject: Re: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
> 
> On 12/17/2014 01:47 PM, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > X86 32-bit machine and kernel use PAE paging, which currently wastes
> > about 4K of memory per process on Linux where we have to reserve an
> > entire page to support a single 256-byte PGD structure.  It would be a
> > very good thing if we could eliminate that wastage.
> >
> 
> 4*8 = 32 bytes, where did 256 bytes come from?

You are right. It should be 32 bytes. I will change the wording in future patch. The real calculation in code is right though.

Thanks.

-Fenghua
