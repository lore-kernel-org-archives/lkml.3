Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936370Ab3DJM6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:58:14 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51980 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab3DJM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:58:13 -0400
Date: Wed, 10 Apr 2013 14:58:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Allow setting period 1
Message-ID: <20130410125808.GC12978@gmail.com>
References: <1362785070-12860-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362785070-12860-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> I had some requests for setting period 1, so that every event of something
> is caught.  To my knowledge there is no limit to 1 on Intel hardware.
> Just remove the check for minimum 2
> 
> If specific CPUs have problems we can black list them.

How have you tested this? The commit that added this quirk mentions very high perf 
load triggering badness unless this quirk is added.

Thanks,

	Ingo
