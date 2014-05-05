Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaEENkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:40:31 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35615 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaEENka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:40:30 -0400
Message-ID: <536794CB.8060903@linuxfoundation.org>
Date: Mon, 05 May 2014 09:40:27 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Organization: Linux Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.15-rc4
References: <CA+55aFz6Sxjy9jdai=TkeB2Rbpu0ydL4-YW4j-S-9oixDu5oZw@mail.gmail.com> <CA+5PVA4Wt19ByW5c__jJWFFz0_0uvnbQeRn13w6S43TMZJt8YA@mail.gmail.com>
In-Reply-To: <CA+5PVA4Wt19ByW5c__jJWFFz0_0uvnbQeRn13w6S43TMZJt8YA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/14 08:38 AM, Josh Boyer wrote:
> Did the patch-3.15-rc4.xz tarball not get uploaded/created on
> kernel.org?  The frontpage doesn't seem to have been updated for -rc4,
> and I can't find it here either:
> 
> https://www.kernel.org/pub/linux/kernel/v3.x/testing/

Looks like it got placed into /v3.x/ instead of /testing/. I'll move it
into /testing/ shortly, which should kick off the site update (the
script only looks for -rc kernels in /testing/).

-K
