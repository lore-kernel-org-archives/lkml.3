Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaAMDia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:38:30 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35257 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAMDi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:38:27 -0500
Message-ID: <52D35FAF.5050805@zankel.net>
Date: Sun, 12 Jan 2014 19:38:23 -0800
From: czankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: linux-next: manual merge of the tip tree with the xtensa tree
References: <20140113142642.6e1944155b1db50d2c70abb4@canb.auug.org.au>
In-Reply-To: <20140113142642.6e1944155b1db50d2c70abb4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for the fix! I actually just got an updated set for most of the 
patches currently in the for_next tree for xtensa and might have to do a 
rebase to integrate them better. I'll include your fix when I come 
across the issue.

Thanks again,
-Chris

On 1/12/14 7:26 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the tip tree got a conflict in
> arch/xtensa/include/asm/barrier.h between commit dbacef090841 ("xtensa:
> add SMP support") from the xtensa tree and commit 93ea02bb8435 ("arch:
> Clean up asm/barrier.h implementations using asm-generic/barrier.h") from
> the tip tree.
>
> I fixed it up (I am pretty sure - see below) and can carry the fix as
> necessary (no action is required).
>

