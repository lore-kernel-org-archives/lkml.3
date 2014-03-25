Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaCYAqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:46:51 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64688 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCYAqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUXoTVbZhopEhwQfxRF0ka1x6J3SmA9YHarN1UWA6QGCBw@mail.gmail.com>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
	<CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
	<20140323164526.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
	<CA+icZUXoTVbZhopEhwQfxRF0ka1x6J3SmA9YHarN1UWA6QGCBw@mail.gmail.com>
Date: Mon, 24 Mar 2014 17:46:48 -0700
X-Google-Sender-Auth: qrUxuZym_sKxOrxa-AQgUfd4c04
Message-ID: <CA+55aFxvACwdNuswQsTENWdmRnjKR_LgThtnAVTBQ91gvDpWvg@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to clarify: the current vfs tree from Al works for you, no new issues?

I was delaying the release first a day, and now I think I'll just do
an rc8 after all (and do the final 3.14 next weekend), but I'd like to
be sure what the status of Al's tree is.

Al, can you send a new pull request with fixed information (assuming I
understood correctly and everything in vfs-land works for Sedat).

> P.S.: [Off-topic] With vanilla -66 kernel I have some OOPS in the
> oom[1..5] tests of LTP. Whom to adress? mm-folks?

Yes, please send to -mm (and cc lkml and me).

            Linus
