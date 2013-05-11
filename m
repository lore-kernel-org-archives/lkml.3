Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3EKF5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 01:57:19 -0400
Received: from blu0-omc3-s24.blu0.hotmail.com ([65.55.116.99]:28314 "EHLO
	blu0-omc3-s24.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab3EKF5H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 01:57:07 -0400
X-EIP: [Nv6ezajNYWqT2nM4VQMoxjfgwCVkclbC]
X-Originating-Email: [yuhongbao_386@hotmail.com]
Message-ID: <BLU177-W369899F15977E6D1D880C0C3A60@phx.gbl>
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: "mingo@kernel.org" <mingo@kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "fernando@oss.ntt.co.jp" <fernando@oss.ntt.co.jp>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Subject: RE: [tip:x86/urgent] x86-64, init:  Do not set NX bits on non-NX
 capable hardware
Date: Fri, 10 May 2013 22:57:06 -0700
Importance: Normal
In-Reply-To: <tip-78d77df71510a96e042de7ba6dbd7998103642cb@git.kernel.org>
References: <1367476850.5660.2.camel@nexus>,<tip-78d77df71510a96e042de7ba6dbd7998103642cb@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 May 2013 05:57:06.0345 (UTC) FILETIME=[5DF84990:01CE4E0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending as plaintext)
> During early init, we would incorrectly set the NX bit even if the NX
> feature was not supported.  Instead, only set this bit if NX is
> actually available and enabled.  We already do very early detection of
> the NX bit to enable it in EFER, this simply extends this detection to
> the early page table mask.
AFAIK the only production x86-64 processor that don't support NX that I know of is the original Nocona D0 stepping.
Must more common are the problem of BIOSes disabling the NX feature.


Yuhong Bao 		 	   		  