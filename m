Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaLRRZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:25:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35806 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaLRRZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:25:51 -0500
Message-ID: <54930E14.30800@zytor.com>
Date: Thu, 18 Dec 2014 09:25:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Glenn Williamson <glenn.p.williamson@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v2] X86-32: Allocate 256 bytes for pgd in PAE paging
References: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1418852859-18852-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 01:47 PM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> X86 32-bit machine and kernel use PAE paging, which currently wastes about
> 4K of memory per process on Linux where we have to reserve an entire page to
> support a single 256-byte PGD structure.  It would be a very good thing if
> we could eliminate that wastage.
> 

4*8 = 32 bytes, where did 256 bytes come from?

	-hpa


