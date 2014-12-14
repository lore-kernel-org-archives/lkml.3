Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaLNVrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 16:47:42 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:59003 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaLNVrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 16:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <20141214202224.GH2672@kvack.org>
References: <20141214202224.GH2672@kvack.org>
Date: Sun, 14 Dec 2014 13:47:32 -0800
X-Google-Sender-Auth: Yk0TGvhCEzfkdaY3Xhr7v5aTcFg
Message-ID: <CA+55aFxV2h1NrE87Zt7U8bsrXgeO=Tf-DyQO8wBYZ=M7WEjxKg@mail.gmail.com>
Subject: Re: [GIT PULL] aio: changes for 3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-aio@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 12:22 PM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> Pavel Emelyanov (1):
>       aio: Make it possible to remap aio ring

So quite frankly, I think this should have had more acks from VM
people. The patch looks ok to me, but it took me by surprise, and I
don't see much any discussion about it on linux-mm either..

                       Linus
