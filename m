Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3EKO4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 10:56:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47549 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab3EKO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 10:56:20 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <BLU177-W369899F15977E6D1D880C0C3A60@phx.gbl>
References: <1367476850.5660.2.camel@nexus>,<tip-78d77df71510a96e042de7ba6dbd7998103642cb@git.kernel.org> <BLU177-W369899F15977E6D1D880C0C3A60@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [tip:x86/urgent] x86-64, init:  Do not set NX bits on non-NX capable hardware
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 11 May 2013 07:55:58 -0700
To: Yuhong Bao <yuhongbao_386@hotmail.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fernando@oss.ntt.co.jp" <fernando@oss.ntt.co.jp>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Message-ID: <6d735c4c-ee73-4f42-baa9-1791bae17ed6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes... But both apply.

Yuhong Bao <yuhongbao_386@hotmail.com> wrote:

>(resending as plaintext)
>> During early init, we would incorrectly set the NX bit even if the NX
>> feature was not supported.  Instead, only set this bit if NX is
>> actually available and enabled.  We already do very early detection
>of
>> the NX bit to enable it in EFER, this simply extends this detection
>to
>> the early page table mask.
>AFAIK the only production x86-64 processor that don't support NX that I
>know of is the original Nocona D0 stepping.
>Must more common are the problem of BIOSes disabling the NX feature.
>
>
>Yuhong Bao 		 	   		  

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
