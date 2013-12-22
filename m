Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3LVTJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 14:09:37 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:42912 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3LVTJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 14:09:35 -0500
MIME-Version: 1.0
In-Reply-To: <20131221230644.GB29743@kvack.org>
References: <CA+55aFyoXCDNfHb+r5b=CgKQLPA1wrU_Tmh4ROZNEt5TPjpODA@mail.gmail.com>
	<20131219181134.GC25385@kmo-pixel>
	<20131219182920.GG30640@kvack.org>
	<CA+55aFzCo_r7ZGHk+zqUjmCW2w7-7z9oxEJjhR66tZ4qZPxnvw@mail.gmail.com>
	<20131219192621.GA9228@kvack.org>
	<CA+55aFz=tEkVAx9VndtCXApDxcw+5T-BxMsVuXp+vMSb05f8Aw@mail.gmail.com>
	<20131219195352.GB9228@kvack.org>
	<20131219202416.GA14519@redhat.com>
	<20131219233854.GD10905@kvack.org>
	<20131220010042.GA32112@redhat.com>
	<20131221230644.GB29743@kvack.org>
Date: Sun, 22 Dec 2013 11:09:34 -0800
X-Google-Sender-Auth: eN7D1QgcvJ2SyBZ1npIEt3lHKJ4
Message-ID: <CA+55aFx3dLwLdo90g0xo_t-iv+8k6TBy+=wQfd1UX3YbDFRFhw@mail.gmail.com>
Subject: Re: [PATCHes - aio / migrate page, please review] Re: bad page state
 in 3.13-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Dave Jones <davej@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 3:06 PM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> Linus, feel free to add my Signed-off-by: to your sanitization of
> aio_setup_ring() as well, as it works okay in my testing.

Nobody commented on your request for comments, so I applied my patch
and pulled your branch, because I'm going to do -rc5 in a few and at
least we want this to get testing.

Dave, let's hope that the leak fixes and reference count fixes solve
your problem.

                Linus
