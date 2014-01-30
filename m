Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaA3W1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:27:20 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:34818 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaA3W1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAHYPw2GborA=wnnVyifmK-Mew0yvdhrk0W69DcWK65XE4jfF8Q@mail.gmail.com>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
	<8761p1m98f.fsf@xmission.com>
	<CA+55aFwrBQJ=kVBXoo2GnBP4xoa3==6WDZfbt-u4OSxz8iQUoA@mail.gmail.com>
	<CAHYPw2GborA=wnnVyifmK-Mew0yvdhrk0W69DcWK65XE4jfF8Q@mail.gmail.com>
Date: Thu, 30 Jan 2014 14:27:15 -0800
X-Google-Sender-Auth: GFid7rNisTUqijnoUp2V_mm7s3w
Message-ID: <CA+55aFxbWMZaLtV1=UR73HXhYb0s7jASdHaEkP4bKjvxLnuo3A@mail.gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 2:15 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
>
> In afs documentation is written that you need to write to these files. See:

Well, but the afs documentation is clearly wrong, since the
"documented" procedure doesn't actually *work*.

So I don't think "it's documented" is a very strong argument.
Documentation is as useful as used toilet paper, if clearly nobody has
ever done what was "documented".

                     Linus
