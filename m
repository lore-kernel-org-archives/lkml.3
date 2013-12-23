Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3LWSRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 13:17:05 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55628 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3LWSRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 13:17:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ8eaTxq5tL1WT_2rsDg5nKwW4xxW_Md6ZTgk9f5DX75cN=pRg@mail.gmail.com>
References: <CAJ8eaTzkKtwM2Xvw_GYRrefUVJg0uzaqFNPJcNc_ffSayQiDUA@mail.gmail.com>
	<CA+55aFyVrrvDzUt0OU4d9YZM8C-N+ycSKEa3+-5nowUoZ=rb8w@mail.gmail.com>
	<20131222143427.GA12544@redhat.com>
	<CAJ8eaTxq5tL1WT_2rsDg5nKwW4xxW_Md6ZTgk9f5DX75cN=pRg@mail.gmail.com>
Date: Mon, 23 Dec 2013 10:17:01 -0800
X-Google-Sender-Auth: ZLpHMScQRSWFHlinK5eoYZaV504
Message-ID: <CA+55aFx__ioTKoT3-t3SQOsr6HLB-dNKGWNwJ=AmBPn3FiYQmA@mail.gmail.com>
Subject: Re: [PATCH] secure unlock_task_sighand() call
From: Linus Torvalds <torvalds@linux-foundation.org>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Vaibhav Shinde <v.bhav.shinde@gmail.com>,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 4:29 AM, naveen yadav <yad.naveen@gmail.com> wrote:
>
> We are facing OOPS during core dump on kernel 3.8.x on ARM target.
>
> So we were doing core review and found this. We do not know whether
> its big issue but thought to share this considering the problem

Can you please post the oops, just in case that has any more hints.
Maybe the serialization is broken somehow on ARM, or there is some
ARM-specific bug. This code _is_ fairly subtle, but I don't think any
of the patches I've seen so far should really fix anything.

              Linus
