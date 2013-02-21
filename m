Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3BUQj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:39:58 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37494 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3BUQj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:39:56 -0500
MIME-Version: 1.0
In-Reply-To: <30665.1361461678@warthog.procyon.org.uk>
References: <30665.1361461678@warthog.procyon.org.uk>
Date: Thu, 21 Feb 2013 08:39:55 -0800
X-Google-Sender-Auth: jv7qtUjzNn_9VLdJM6a277lvi8w
Message-ID: <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 7:47 AM, David Howells <dhowells@redhat.com> wrote:
>
> Can you pull this patchset please?

Not without a lot more discussion first.

Quite frankly, this is f*cking moronic. The whole thing seems to be
designed around stupid interfaces, for completely moronic reasons. Why
should we do this?

I already dislike our existing X.509 parser. And this makes the
idiotic complicated interfaces, and now it goes up to 11.

            Linus
