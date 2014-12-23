Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaLWEMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:12:25 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:43673 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaLWEMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:12:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141223131749.78087632@canb.auug.org.au>
References: <20141223131749.78087632@canb.auug.org.au>
Date: Mon, 22 Dec 2014 20:12:22 -0800
X-Google-Sender-Auth: TJNzpKXjX0YKyQPdFn515pD0LPo
Message-ID: <CA+55aFxjeunxnfc8L1r=GWCBUf5uU=bcnDeu6VygMbsCxVgB0Q@mail.gmail.com>
Subject: Re: linux-next: missing merge fix for the access_once tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 6:17 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> I have been carrying this merge fix patch for some time.  It should
> have gone into the merge of the access_once tree.

No, you had a different tree that got merged into linux-next, that
made it an error to do ACCESS_ONCE() on a structure.

The thing I merged didn't actually have that final commit, exactly so
that things wouldn't break from missing conversions.

So that patch isn't wrong, but it also isn't exactly a required fix
until the next merge window..

                      Linus
