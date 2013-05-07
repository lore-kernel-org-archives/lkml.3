Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3EGPrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:47:52 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:36942 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757775Ab3EGPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:47:51 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 11:47:51 EDT
Date: Tue, 7 May 2013 15:40:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Glauber Costa <glommer@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <CAOJsxLGW6pMeLJ=XRzg1JU6QuT0E+vcFSSay1FbG=-N27aSing@mail.gmail.com>
Message-ID: <0000013e7fa6ca33-aa0a34a3-0179-4354-a1e7-b22e5f3570cd-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com> <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp> <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
 <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp> <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com> <201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp> <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
 <CAOJsxLGvbJ+FNq8J3j1FHz9gjo7vGgfTyWQT1vvy0D3Ykq8SyA@mail.gmail.com> <0000013e7f60169e-47b0bd92-a757-41da-8b30-fa78511fe298-000000@email.amazonses.com> <CAOJsxLGW6pMeLJ=XRzg1JU6QuT0E+vcFSSay1FbG=-N27aSing@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.07-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013, Pekka Enberg wrote:

> On Tue, May 7, 2013 at 5:23 PM, Christoph Lameter <cl@linux.com> wrote:
> > Well this is because you did not take the patch that changed the way
> > KMALLOC_SHIFT_HIGH is treated.
>
> Is that still needed? I only took the ones Tetsuo said were needed to
> fix the issue at hand.

If his tests work then I guess not. Queue for later.


