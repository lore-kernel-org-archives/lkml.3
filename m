Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3LJD6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:58:40 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:40523 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3LJD6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:58:35 -0500
MIME-Version: 1.0
In-Reply-To: <1386640667.32037.53.camel@pasglop>
References: <1386640667.32037.53.camel@pasglop>
Date: Mon, 9 Dec 2013 19:58:34 -0800
X-Google-Sender-Auth: d0dbIv_r_qnPKbcTwPhi9DvL2dQ
Message-ID: <CA+55aFz_VXtkX0vH+T2kGpzA90Zqys=_quJFq3fGT68YTCnBtw@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 5:57 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Here are a handful of powerpc fixes for 3.13.

Grr.

I've pulled it, but looking at that history, it's just pure and utter
f*cking garbage.

It was rebased *minutes* before sending it, as far as I can tell. Why?

And it has a pointless merge that you must have created with "--no-ff"
for no apparent good reason.

WTF? What the hell happened here, and why? As mentioned, it's in my
tree, but I was *this* close to just unpulling and saying "fuck that"
when I started looking at it.

              Linus
