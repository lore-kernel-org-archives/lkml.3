Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3GCLh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:37:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51603 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab3GCLhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:55 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130703155914.cc0f48d817f4ca02e3bb18a2@canb.auug.org.au>
References: <20130703155914.cc0f48d817f4ca02e3bb18a2@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: linux-next: manual merge of the xen-two tree with the tip tree
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 03 Jul 2013 07:36:59 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Message-ID: <38bbecb3-4426-48a1-ba19-805769b15a4c@email.android.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>Hi Konrad,
>
>Today's linux-next merge of the xen-two tree got a conflict in
>arch/x86/xen/time.c between commit 5584880e44e4 ("x86: xen: Sync the
>wallclock when the system time is set") from the tip tree and commit
>c9d76a24a289 ("xen/time: Don't leak interrupt name when offlining")
>from
>the xen-two tree.
>
>I fixed it up (see below) and can carry the fix as necessary (no action
>is required).

Yes.  Thanks for fixing it up. 
-- 
Sent from my Android phone. Please excuse my brevity.
