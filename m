Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaCWRBD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 13:01:03 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:47562 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaCWRBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 13:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140323164526.GJ18016@ZenIV.linux.org.uk>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
	<CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
	<20140323164526.GJ18016@ZenIV.linux.org.uk>
Date: Sun, 23 Mar 2014 10:01:00 -0700
X-Google-Sender-Auth: d2quzYtiHzraChJCBKCPNrPwSRM
Message-ID: <CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 9:45 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> It's easier to skip checking the overflow on prepend() of "\0" in the
> beginning of the whole thing and just let the next operation to fail.
> That's where the corner case comes from.

Ok, I'll buy the first four commits. Let's wait for Sedat's report on the rest.

                  Linus
