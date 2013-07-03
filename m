Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3GCA6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:58:17 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:65097 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3GCA6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130703005419.GA7744@kroah.com>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
	<20130703094529.99444050e676467d281a3b51@canb.auug.org.au>
	<CA+55aFxdAHqEhnV-zKwExVfBAvw=k8+GprTGniNz=TpJM6obtQ@mail.gmail.com>
	<20130703005419.GA7744@kroah.com>
Date: Tue, 2 Jul 2013 17:58:15 -0700
X-Google-Sender-Auth: vzbnP4ftslewpev9WPOHaZboy-Y
Message-ID: <CA+55aFxdNVX9koH=GViv1Haj3kU07PD-CTKCNuWrm-c-BF3mQw@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 updates for 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 5:54 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jul 02, 2013 at 05:02:21PM -0700, Linus Torvalds wrote:
>>
>> I'm really not convinced this whole Lustre thing was correctly
>> handled. Merging it into stable and yet being in such bad shape that
>> it isn't enabled even there? I just dunno. But I have the turd in my
>> tree now, let's hope it gets fixed up.
>
> It's in "staging", not "stable" :)

Yes. But what was the reason to actually merge it even there? And once
it gets merged, disabling it again rather than fixing the problems it
has?

This is a filesystem that Intel apparently wants to push. I think it
would have been a better idea to push back a bit and say "at least
clean it up a bit first". It's not like Intel is one of the clueless
companies that couldn't have done so and need help from the community.

As it is, it got merged, and apparently things are going *backwards*
rather than forwards because it doesn't even show up in the
allmodconfig builds I do.

               Linus
