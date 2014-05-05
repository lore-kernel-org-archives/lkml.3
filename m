Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbaEEOAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:00:22 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:55861 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbaEEOAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <536794CB.8060903@linuxfoundation.org>
References: <CA+55aFz6Sxjy9jdai=TkeB2Rbpu0ydL4-YW4j-S-9oixDu5oZw@mail.gmail.com>
	<CA+5PVA4Wt19ByW5c__jJWFFz0_0uvnbQeRn13w6S43TMZJt8YA@mail.gmail.com>
	<536794CB.8060903@linuxfoundation.org>
Date: Mon, 5 May 2014 10:00:19 -0400
X-Google-Sender-Auth: 1eQANCS0BxH_vjWxPC4gOJGzehs
Message-ID: <CA+5PVA7HQ5txe_PTGD1wdrOLA1LEw1B6eXyu3i=riLjB_cevDA@mail.gmail.com>
Subject: Re: Linux 3.15-rc4
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 9:40 AM, Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
> On 05/05/14 08:38 AM, Josh Boyer wrote:
>> Did the patch-3.15-rc4.xz tarball not get uploaded/created on
>> kernel.org?  The frontpage doesn't seem to have been updated for -rc4,
>> and I can't find it here either:
>>
>> https://www.kernel.org/pub/linux/kernel/v3.x/testing/
>
> Looks like it got placed into /v3.x/ instead of /testing/. I'll move it
> into /testing/ shortly, which should kick off the site update (the
> script only looks for -rc kernels in /testing/).

Ah, great.  Thanks for the quick reply.

josh
