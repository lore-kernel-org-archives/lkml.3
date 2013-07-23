Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3GWQaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:30:39 -0400
Received: from rrcs-98-103-208-26.central.biz.rr.com ([98.103.208.26]:60943
	"HELO wolff.to" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S933285Ab3GWQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:30:38 -0400
Date: Tue, 23 Jul 2013 11:29:13 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
Message-ID: <20130723162913.GA25886@wolff.to>
References: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
 <20130723151009.GA5971@wolff.to>
 <CAB3wodfLzHMS1b3kQXKYvmWLLoYOhenwmMfS-cSU3w1gLFCh-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAB3wodfLzHMS1b3kQXKYvmWLLoYOhenwmMfS-cSU3w1gLFCh-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 17:17:30 +0100,
   Phillip Lougher <phillip.lougher@gmail.com> wrote:
>
>In otherwords I don't think it's wise yet to merge LZ4 onto stable,
>not until at least there's some positive feedback on the mailing list.
>
>Thoughts?  Maybe some positive feedback? :-)

I think it makes sense to tie inclusion in the kernel with inclusion 
into the stable branch. If this gets into the 3.11 kernel, I'm going 
to want to get it into Fedora releases that use that kernel. This 
will initially be Fedora 20 (which will branch from rawhide in a couple 
of weeks) and will eventually be in Fedora 19 and probably Fedora 18. 
So I'd like to see it in stable, since I would feel less comfortable 
using the master branch.

If LZ4 support isn't in the kernel I think that there isn't a lot of 
need for support in Fedora since I don't think many people use it 
for archiving. It mostly gets used for live images. I'll make sure 
that LZ4 can be used for them, but I suspect most people will still 
prefer xz for them. But probably at least some people would prefer 
faster decompression rather than minimal size. As flash drives get 
bigger (for the same cost) more people will probably prefer speed over 
size.
