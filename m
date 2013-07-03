Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3GCAyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:54:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46898 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981Ab3GCAyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:54:22 -0400
X-Sasl-enc: w8XvH0gtTalY8jslSfN1RVKgB4zKje4G2SlrmqlOeypt 1372812860
Date: Tue, 2 Jul 2013 17:54:19 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Message-ID: <20130703005419.GA7744@kroah.com>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
 <20130703094529.99444050e676467d281a3b51@canb.auug.org.au>
 <CA+55aFxdAHqEhnV-zKwExVfBAvw=k8+GprTGniNz=TpJM6obtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxdAHqEhnV-zKwExVfBAvw=k8+GprTGniNz=TpJM6obtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 05:02:21PM -0700, Linus Torvalds wrote:
> On Tue, Jul 2, 2013 at 4:45 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > The merge of the ext4 tree and the staging tree needs the following fixup
> > (at least).  It is not a biggie, as that code in staging is actually
> > disabled at the moment.
> 
> Argh. I merged both of these before this email came in, so now my
> merge doesn't have this.
> 
> That said, as you mention, lustre is currently disabled due to bigger
> build issues, so I guess it's not a big deal.
> 
> Who is going to be the main Lustre maintainer? I'm assuming (based on
> the commits I see) it's Andreas Dilger?
> 
> I'm really not convinced this whole Lustre thing was correctly
> handled. Merging it into stable and yet being in such bad shape that
> it isn't enabled even there? I just dunno. But I have the turd in my
> tree now, let's hope it gets fixed up.

It's in "staging", not "stable" :)

And yeah, I thought it built properly, as it was running on lots of
systems for years, but it turns out, no one ever tested non-x86 builds
of the thing, and linux-next just choked all over it, which is why it is
disabled from the build for 3.11.  We will get it all building properly
for 3.12, so no rush on these types of ext4 patches, Andreas and the
other Lustre developers will get it resolved.

thanks,

greg k-h
