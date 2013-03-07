Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab3CGVvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:51:42 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40942 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab3CGVvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130307.164935.1743147312624311513.davem@davemloft.net>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
	<20130307213819.GB19543@redhat.com>
	<CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
	<20130307.164935.1743147312624311513.davem@davemloft.net>
Date: Thu, 7 Mar 2013 13:51:40 -0800
X-Google-Sender-Auth: KC_fXAzt1dt1hZD414sRxO-gGDQ
Message-ID: <CA+55aFz1__oKtg-+t4Lagpif=G3GLh=GOe3Hjk9xtzBE=U+BUg@mail.gmail.com>
Subject: Re: ipc/testmsg GPF.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 1:49 PM, David Miller <davem@davemloft.net> wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 7 Mar 2013 13:45:27 -0800
>
>> Adding Davem to the list, since this looks like networking.
>
> I'd like to help but this looks more like sysv IPC than
> networking. :-)

Yeah, I'm a f*cking moron.

msgrcv vs recvmsg. What can I say? We see so little msgrcv that I
don't have the mental associations for it at all.

                Linus
