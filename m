Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3BZR2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:28:40 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:36749 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3BZR2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:28:39 -0500
MIME-Version: 1.0
In-Reply-To: <51270182.4080205@oberhumer.com>
References: <51270182.4080205@oberhumer.com>
Date: Tue, 26 Feb 2013 09:28:38 -0800
X-Google-Sender-Auth: Zb7qRW-Yxq9bcXDg_TNlMILmq4k
Message-ID: <CA+55aFy0jezoatAQKOYDPHifG9Lhyp2ZC=fYTFU2tpzxOhTa3Q@mail.gmail.com>
Subject: Re: [GIT PULL] Update LZO compression code for v3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 9:26 PM, Markus F.X.J. Oberhumer
<markus@oberhumer.com> wrote:
>
> please pull my "lzo-update" branch from
>
>   git://github.com/markus-oberhumer/linux.git lzo-update

I *really* want github (and other general hosting) pull requests to be
for signed tags, so that I can see your gpg key and there is some real
trail of who things got pulled from.

I prefer he signed tags even from trusted machines, because they allow
for submitters to add comments directly for the merge, but for
untrusted general hosting sites I will simply refuse to pull without
them.

                Linus
