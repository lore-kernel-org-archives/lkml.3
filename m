Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbaDPAFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:05:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39339 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDPAFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:05:47 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joe Perches <joe@perches.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: convert some level-less printks to pr_*
References: <1395942859-11611-1-git-send-email-mitchelh@codeaurora.org>
	<1395942859-11611-2-git-send-email-mitchelh@codeaurora.org>
	<20140414155526.96b0832bf4660c026bc3a1d9@linux-foundation.org>
	<vnkwvbuaywki.fsf@mitchelh-linux.qualcomm.com>
Date: Tue, 15 Apr 2014 17:05:53 -0700
In-Reply-To: <vnkwvbuaywki.fsf@mitchelh-linux.qualcomm.com> (Mitchel
	Humpherys's message of "Tue, 15 Apr 2014 16:58:21 -0700")
Message-ID: <vnkwmwfmyw7y.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15 2014 at 04:58:21 PM, Mitchel Humpherys <mitchelh@codeaurora.org> wrote:
> On Mon, Apr 14 2014 at 03:55:26 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> And all of this should be described and justified in the changelog,
>> please.
>
> Will send a v3 shortly. Thanks for your comments.

Make that a v4, I actually already sent a v3. You'd think I could get a
printk change right on v1 :). We'll get there.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
