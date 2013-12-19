Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3LSTpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:45:41 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:52504 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3LSTpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:45:39 -0500
MIME-Version: 1.0
In-Reply-To: <20131219192621.GA9228@kvack.org>
References: <20131219040738.GA10316@redhat.com>
	<CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
	<20131219155313.GA25771@redhat.com>
	<CA+55aFyoXCDNfHb+r5b=CgKQLPA1wrU_Tmh4ROZNEt5TPjpODA@mail.gmail.com>
	<20131219181134.GC25385@kmo-pixel>
	<20131219182920.GG30640@kvack.org>
	<CA+55aFzCo_r7ZGHk+zqUjmCW2w7-7z9oxEJjhR66tZ4qZPxnvw@mail.gmail.com>
	<20131219192621.GA9228@kvack.org>
Date: Fri, 20 Dec 2013 04:45:38 +0900
X-Google-Sender-Auth: xFXimc7AtQL87oFFV4lJKSA47lU
Message-ID: <CA+55aFz=tEkVAx9VndtCXApDxcw+5T-BxMsVuXp+vMSb05f8Aw@mail.gmail.com>
Subject: Re: bad page state in 3.13-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 4:26 AM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> Okay, I'll rewriting it to use truncate to free the pages.

It already does that in put_aio_ring_file() afaik. No?

                Linus
