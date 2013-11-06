Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872Ab3KFFHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:07:25 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59534 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KFFHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:07:24 -0500
Date: Tue, 5 Nov 2013 21:07:45 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Olof Johansson <olof@lixom.net>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] block: Revert bio_clone() default behaviour
Message-ID: <20131106050745.GA17641@moria.home.lan>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
 <CAOesGMjiPuqqP4oxd8vmvpbu5JZb=Nru59p5zX5KydAarSp2Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMjiPuqqP4oxd8vmvpbu5JZb=Nru59p5zX5KydAarSp2Rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 09:02:19PM -0800, Olof Johansson wrote:
> Hi,
> 
> On Tue, Nov 5, 2013 at 7:48 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> 
> > Chris, Olaf, can you two in particular test this? I have tested the bounce
> > buffer code (and bcache), but Jens told me today there was an md bug that I
> > _still_ can't find any emails about so I'm not sure what to test for that.
> 
> (I'm guessing you mean me and not some German person here. :-)
> 
> What is this expected to apply on top of? It doesn't apply cleanly on
> the 20131105 -next tree which is where I had been seeing the issues.

Sorry - it's on top of Jens' for-3.13/core branch,
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
