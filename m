Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaLOXod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:44:33 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55177 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaLOXob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:44:31 -0500
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Elliott <elliott@hp.com>, Matt Wagantall <mattw@codeaurora.org>
Subject: Re: [PATCH v9] iopoll: Introduce memory-mapped IO polling macros
References: <1418686280-12972-1-git-send-email-mitchelh@codeaurora.org>
Date: Mon, 15 Dec 2014 15:44:28 -0800
In-Reply-To: <1418686280-12972-1-git-send-email-mitchelh@codeaurora.org>
	(Mitchel Humpherys's message of "Mon, 15 Dec 2014 15:31:20 -0800")
Message-ID: <vnkw1to0h40z.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15 2014 at 03:31:20 PM, Mitchel Humpherys <mitchelh@codeaurora.org> wrote:
> From: Matt Wagantall <mattw@codeaurora.org>
>
> It is sometimes necessary to poll a memory-mapped register until its value
> satisfies some condition. Introduce a family of convenience macros that do
> this. Tight-looping, sleeping, and timing out can all be accomplished using
> these macros.
>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Robert Elliott <elliott@hp.com>
> Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
> Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
> ---
> v8..v9:
>   - Added note in comments about max sleep time (Rob Elliott)

Sorry, just noticed that I somehow dropped these additional comments
that Rob requested...  Let me send a v10 that actually includes them.
Please ignore this version.


-Mitch

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
