Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaC3Wjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 18:39:36 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:61959 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaC3Wjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 18:39:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140330205537.GM18016@ZenIV.linux.org.uk>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
	<CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
	<20140323164526.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
	<CA+icZUXoTVbZhopEhwQfxRF0ka1x6J3SmA9YHarN1UWA6QGCBw@mail.gmail.com>
	<CA+55aFxvACwdNuswQsTENWdmRnjKR_LgThtnAVTBQ91gvDpWvg@mail.gmail.com>
	<CA+icZUWD7NekSyNa2Keg=+teDCGg-Ttc5Xb4wfKA-56FMwGSeg@mail.gmail.com>
	<CA+55aFwKqDzNCd1wQYZqKXb3DDj2bHYjHCYjDAkWJwPhuvR17A@mail.gmail.com>
	<20140330203307.GL18016@ZenIV.linux.org.uk>
	<20140330205537.GM18016@ZenIV.linux.org.uk>
Date: Sun, 30 Mar 2014 15:39:33 -0700
X-Google-Sender-Auth: G22bXLkvDEyU-SKQXHfIiv9_CTQ
Message-ID: <CA+55aFw5WjjHPP0SZo8fZefG5_S4F=-V_oa0HV4sm+G167-4iA@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 1:55 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Commit ID of that branch should be 7fc5aaa083922420e2dec5d985420cb5f959b1ce;
> diffs are the same as what sat there since last Sunday, commit messages
> got updated a bit.

Ugh. You have apparently rebased the parts that I already pulled too,
which is annoying and causes duplicate commits.

             Linus
