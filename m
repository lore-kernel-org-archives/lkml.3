Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420Ab3ECT2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:28:16 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:35956 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763334Ab3ECT2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:28:15 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 15:28:15 EDT
Date: Fri, 3 May 2013 19:21:35 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305040348.CIF81716.OStQOHFJMFLOVF@I-love.SAKURA.ne.jp>
Message-ID: <0000013e6bd7a766-8473586c-7937-4129-bad1-a4198acdddcf-000000@email.amazonses.com>
References: <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com> <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp> <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
 <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp> <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com> <201305040348.CIF81716.OStQOHFJMFLOVF@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.03-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 May 2013, Tetsuo Handa wrote:

>   Subject: slab: Return NULL for oversized allocations
>   (Date: Fri, 3 May 2013 15:43:18 +0000)
>
> and
>
>   Subject: Fix bootstrap creation of kmalloc caches
>   (Date: Fri, 3 May 2013 18:04:18 +0000)
>
> on linux-next-20130426 made my kernel boots fine and passes the allocation
> testcases. Thank you.

Ok could I see the kernel logs with the warnings?

