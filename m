Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbbA0IOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:14:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39457 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbbA0IOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:14:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hong Xu <hong@topbug.net>
Subject: Re: linux-next: build failure after merge of the wireless-drivers-next tree
References: <20150127190349.22ff92e8@canb.auug.org.au>
Date: Tue, 27 Jan 2015 10:13:55 +0200
In-Reply-To: <20150127190349.22ff92e8@canb.auug.org.au> (Stephen Rothwell's
	message of "Tue, 27 Jan 2015 19:03:49 +1100")
Message-ID: <87y4ooej3w.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> After merging the wireless-drivers-next tree, today's linux-next build
> (powerpc allyesconfig) failed like this:
>
> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x29d0): multiple definition of `led_blink'
> drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x1654): first defined here
>
> Caused by commit 3a939a671225 ("ath9k_htc: Add a module parameter to
> disable blink").
>
> I have reverted that commit for today.

Sorry about that, we have a patch pending to fix it:

https://patchwork.kernel.org/patch/5699001/

-- 
Kalle Valo
