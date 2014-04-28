Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaD1GDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:03:05 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:44101 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaD1GDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:03:01 -0400
MIME-Version: 1.0
In-Reply-To: <535AF527.80601@redhat.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-22-git-send-email-lftan@altera.com>
	<535AF527.80601@redhat.com>
Date: Mon, 28 Apr 2014 14:03:00 +0800
X-Google-Sender-Auth: d5yj0q57ZT0AIopsXlasW9y_F7s
Message-ID: <CAFiDJ58W+BkjqYurWTdWhoOJjOMBGzvnRvxjKeyJVKCJHkNMGA@mail.gmail.com>
Subject: Re: [PATCH 25/28] nios2: ptrace support
From: Ley Foon Tan <lftan@altera.com>
To: Pedro Alves <palves@redhat.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 7:52 AM, Pedro Alves <palves@redhat.com> wrote:
> Does this support PTRACE_GETREGSET / PTRACE_SETREGSET ?
>
> IMO, the kernel shouldn't accept ports without those anymore.
>
> And IMHO, we shouldn't even allow new ports having PTRACE_GETREGS.
>
> http://sourceware.org/ml/archer/2010-q3/msg00193.html
>

It doesn't support PTRACE_GETREGSET / PTRACE_SETREGSET now.
We will look into this.

Regards
Ley Foon
