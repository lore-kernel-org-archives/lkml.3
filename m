Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3GCACX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:02:23 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35220 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3GCACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:02:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130703094529.99444050e676467d281a3b51@canb.auug.org.au>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
	<20130703094529.99444050e676467d281a3b51@canb.auug.org.au>
Date: Tue, 2 Jul 2013 17:02:21 -0700
X-Google-Sender-Auth: 4SYXbSF7bl4VMrgDaG0pIWKlCtc
Message-ID: <CA+55aFxdAHqEhnV-zKwExVfBAvw=k8+GprTGniNz=TpJM6obtQ@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 updates for 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 4:45 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> The merge of the ext4 tree and the staging tree needs the following fixup
> (at least).  It is not a biggie, as that code in staging is actually
> disabled at the moment.

Argh. I merged both of these before this email came in, so now my
merge doesn't have this.

That said, as you mention, lustre is currently disabled due to bigger
build issues, so I guess it's not a big deal.

Who is going to be the main Lustre maintainer? I'm assuming (based on
the commits I see) it's Andreas Dilger?

I'm really not convinced this whole Lustre thing was correctly
handled. Merging it into stable and yet being in such bad shape that
it isn't enabled even there? I just dunno. But I have the turd in my
tree now, let's hope it gets fixed up.

               Linus
