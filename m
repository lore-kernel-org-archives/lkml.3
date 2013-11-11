Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3KKNaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:30:35 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:64154 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3KKNa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:30:29 -0500
MIME-Version: 1.0
In-Reply-To: <20131111131927.GA7258@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
	<1383871600-3831-4-git-send-email-felipe.contreras@gmail.com>
	<20131111131927.GA7258@gmail.com>
Date: Mon, 11 Nov 2013 07:30:24 -0600
Message-ID: <CAMP44s3hnOHs61r_7U_0P9+h3EX59VEKfAbGHyc49dvTSDqJXg@mail.gmail.com>
Subject: Re: [PATCH 3/3] panic: enable local IRQs for restart timeout too
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 7:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>
> The changelog is missing and the title is not self-explanatory.

Either the local IRQs should be enabled for both the restart and halt
blinks, or it shouldn't be enabled for either. Why enable them for
halt, but not restart?

I think enabling them for restart too makes sense.

-- 
Felipe Contreras
