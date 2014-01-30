Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbaA3VuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:50:19 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56097 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaA3VuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:50:16 -0500
MIME-Version: 1.0
In-Reply-To: <8761p1m98f.fsf@xmission.com>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
	<8761p1m98f.fsf@xmission.com>
Date: Thu, 30 Jan 2014 13:50:15 -0800
X-Google-Sender-Auth: 9gDJ9_UOhwKbQF-sIj9aBobA0PI
Message-ID: <CA+55aFwrBQJ=kVBXoo2GnBP4xoa3==6WDZfbt-u4OSxz8iQUoA@mail.gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 1:48 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> These files have been read-only since this code was merged in 2002.
> Over a decade of not being used seems like a strong indication that no
> one cares about the write path.

I think this is a pretty strong argument. Counter-arguments, anybody?

                     Linus
