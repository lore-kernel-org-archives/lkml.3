Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaHEQx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:53:27 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:59425 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaHEQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAKbGBLha7c2aLLRxkAmXk6_P+g6Q3OMWVFSCLcyuE1YybCjmdg@mail.gmail.com>
References: <20140805131758.3afa6b0b@notabene.brown>
	<CA+55aFxDQ8fE16uKPfjU-nBnvfjWHz3ib5mo1BDn2=JKXVQQmQ@mail.gmail.com>
	<20140805045417.GA27012@loki.us-west-2.compute.internal>
	<CAKbGBLha7c2aLLRxkAmXk6_P+g6Q3OMWVFSCLcyuE1YybCjmdg@mail.gmail.com>
Date: Tue, 5 Aug 2014 09:53:24 -0700
X-Google-Sender-Auth: xvFSWtKHI9rlvY_Q3VT2AvEj7pg
Message-ID: <CA+55aFxTg-_hG14pqRCntHBsVvVgcVKiTLnDvOJPF=9J6CtiJw@mail.gmail.com>
Subject: Re: Is lockref_get_not_zero() really correct in dget_parent()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Noonan <steven@uplinklabs.net>
Cc: NeilBrown <neilb@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 9:56 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>
> Er, grep failed me. The above delta to gfs2 is obviously bogus.

Yeah, and looking at the patch, I think the "make lockref count
signed" should be a separate patch.

            Linus
