Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaC0GOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 02:14:31 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49563 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaC0GO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 02:14:29 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+55aFwKqDzNCd1wQYZqKXb3DDj2bHYjHCYjDAkWJwPhuvR17A@mail.gmail.com>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
	<CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
	<20140323164526.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
	<CA+icZUXoTVbZhopEhwQfxRF0ka1x6J3SmA9YHarN1UWA6QGCBw@mail.gmail.com>
	<CA+55aFxvACwdNuswQsTENWdmRnjKR_LgThtnAVTBQ91gvDpWvg@mail.gmail.com>
	<CA+icZUWD7NekSyNa2Keg=+teDCGg-Ttc5Xb4wfKA-56FMwGSeg@mail.gmail.com>
	<CA+55aFwKqDzNCd1wQYZqKXb3DDj2bHYjHCYjDAkWJwPhuvR17A@mail.gmail.com>
Date: Thu, 27 Mar 2014 07:14:27 +0100
Message-ID: <CA+icZUU+04SGL4dXyOzhwDM43EthZUnFCeky-sG4NUqLVSWduQ@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 9:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 26, 2014 at 9:36 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> Looking at [1] you did not pull-in the new changes.
>> Are you waiting for a new pull-request?
>
> Yeah, with the top commit updated, I'd like to make sure I get the right pull.
>

AFAICS, it was a typo...

s/hlist_del_rcu()/hlist_del_init_rcu()

- Sedat -
