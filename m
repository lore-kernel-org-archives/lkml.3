Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3EGO25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:28:57 -0400
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:46846 "EHLO
	a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108Ab3EGO2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:28:55 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 10:28:55 EDT
Date: Tue, 7 May 2013 14:23:23 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Glauber Costa <glommer@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <CAOJsxLGvbJ+FNq8J3j1FHz9gjo7vGgfTyWQT1vvy0D3Ykq8SyA@mail.gmail.com>
Message-ID: <0000013e7f60169e-47b0bd92-a757-41da-8b30-fa78511fe298-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com> <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp> <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
 <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp> <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com> <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp> <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
 <CAOJsxLGvbJ+FNq8J3j1FHz9gjo7vGgfTyWQT1vvy0D3Ykq8SyA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.07-54.240.9.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013, Pekka Enberg wrote:

> On Fri, May 3, 2013 at 9:04 PM, Christoph Lameter <cl@linux.com> wrote:
> > -       for (i = KMALLOC_SHIFT_LOW; i < KMALLOC_SHIFT_HIGH; i++)
>
> This didn't match what I had in my tree. I fixed it by hand but please
> verify the end result:
>
> https://git.kernel.org/cgit/linux/kernel/git/penberg/linux.git/commit/?h=slab/next&id=8a965b3baa89ffedc73c0fbc750006c631012ced
>
Well this is because you did not take the patch that changed the way
KMALLOC_SHIFT_HIGH is treated.

The patch above looks fine though.


