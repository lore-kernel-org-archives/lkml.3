Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab3EFUYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:24:44 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:53082 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3EFUYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
	<201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
	<0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
	<201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
	<0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
	<201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
	<0000013e6b90e65e-e0e184d9-7da5-4873-9572-3b40958552e2-000000@email.amazonses.com>
Date: Mon, 6 May 2013 23:24:40 +0300
X-Google-Sender-Auth: EQPcFMwNBakeJimMhm8UxtG7wdI
Message-ID: <CAOJsxLGvbJ+FNq8J3j1FHz9gjo7vGgfTyWQT1vvy0D3Ykq8SyA@mail.gmail.com>
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Glauber Costa <glommer@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 9:04 PM, Christoph Lameter <cl@linux.com> wrote:
> -       for (i = KMALLOC_SHIFT_LOW; i < KMALLOC_SHIFT_HIGH; i++)

This didn't match what I had in my tree. I fixed it by hand but please
verify the end result:

https://git.kernel.org/cgit/linux/kernel/git/penberg/linux.git/commit/?h=slab/next&id=8a965b3baa89ffedc73c0fbc750006c631012ced
