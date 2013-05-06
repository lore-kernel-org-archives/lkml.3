Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3EFNqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:46:50 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:57708 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431Ab3EFNqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:46:49 -0400
Date: Mon, 6 May 2013 13:46:39 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305040915.AID02071.FHVQJtOFOMOLSF@I-love.SAKURA.ne.jp>
Message-ID: <0000013e7a18153d-4b59eaf6-0fcd-4eec-b357-31d3d40baa7d-000000@email.amazonses.com>
References: <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com><201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp><0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com><201305040348.CIF81716.OStQOHFJMFLOVF@I-love.SAKURA.ne.jp><0000013e6bd7a766-8473586c-7937-4129-bad1-a4198acdddcf-000000@email.amazonses.com>
 <201305040915.AID02071.FHVQJtOFOMOLSF@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.06-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 May 2013, Tetsuo Handa wrote:

> Christoph Lameter wrote:
> > Ok could I see the kernel logs with the warnings?
> Sure.

These are exclusively from the module load. So the kernel seems to be
clean of large kmalloc's ?


