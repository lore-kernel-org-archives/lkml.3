Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3KVVTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:19:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:51901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab3KVVTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:19:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,753,1378882800"; 
   d="scan'208";a="438268480"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: enable DMA CMA with swiotlb
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
	<528D4A1A.2050100@zytor.com>
	<CAC5umyh0Hfx3NgHX11eqskuifhrdYGB8L1nx1u0YUdBGchRTxw@mail.gmail.com>
	<528E4CBA.8000808@zytor.com>
	<CAC5umygUgSjUMFECDXAjmSPzpfUZ6=jRhZWhd5hTT2-eO6Oh6Q@mail.gmail.com>
	<528F71F8.4070902@zytor.com>
Date: Fri, 22 Nov 2013 13:19:04 -0800
In-Reply-To: <528F71F8.4070902@zytor.com> (H. Peter Anvin's message of "Fri,
	22 Nov 2013 07:02:16 -0800")
Message-ID: <87fvqow2wn.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> If you have a real iotlb, why would you need contiguous memory?

iotlb is often slow.

Another use case is allocating 1GB pages at runtime.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
