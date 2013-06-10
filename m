Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3FJRiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:38:19 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43790 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3FJRiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:38:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+QCeVRdOOuh4aVZsQhucBNETnDp5OhAZguigLTbyD9bOONO1A@mail.gmail.com>
References: <1370845742-18919-1-git-send-email-yinghai@kernel.org>
	<CA+QCeVRdOOuh4aVZsQhucBNETnDp5OhAZguigLTbyD9bOONO1A@mail.gmail.com>
Date: Mon, 10 Jun 2013 10:38:16 -0700
X-Google-Sender-Auth: AcW_OtpSShGGZAaXsTUppXw2tJc
Message-ID: <CAE9FiQXacn2abVKeBhTazgRBCS9EtiACs=fbB6_Y27ZpLOTq3w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] x86, range: Do not add new blank slot with add_range_with_merge
From: Yinghai Lu <yinghai@kernel.org>
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 3:55 AM, Sergey Meirovich <rathamahata@gmail.com> wrote:

> patches 1,2(latest one) have not helped me on 3.9.5:

So v1:
https://patchwork.kernel.org/patch/2694981/
https://patchwork.kernel.org/patch/2694971/

and v2:
https://patchwork.kernel.org/patch/2695891/
https://patchwork.kernel.org/patch/2695881/

Neither of two versions fix the problem on your setup?

Can you post boot log with mtrr_cleanup_debug on 3.9.4?

Thanks

Yinghai
