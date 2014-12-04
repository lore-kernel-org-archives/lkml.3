Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaLDObQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:31:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbaLDObO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:31:14 -0500
Date: Thu, 4 Dec 2014 15:31:12 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Ulf Hansson <ulf.hansson@linaro.org>,
        Dong Aisheng <dongas86@gmail.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.or>,
        Dong Aisheng-B29396 <b29396@freescale.com>, r64343@freescale.com
Subject: Re: WARNING: at fs/fs-writeback.c when plug out SD card after system
 suspend/resume
Message-ID: <20141204143112.GA15657@quack.suse.cz>
References: <CAA+hA=R2x5dUkZAh9=nHLsmaqA5YiAjEya-vQnjLx6i7fruV1w@mail.gmail.com>
 <20141204124139.GC8569@quack.suse.cz>
 <CAPDyKFphwNUUV-e8SuZDEutMCu_a-S9cEP08V0DwUJywa6PtOg@mail.gmail.com>
 <20141204140835.GA15108@quack.suse.cz>
 <20141204141625.GA15219@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204141625.GA15219@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-12-14 09:16:25, Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 04, 2014 at 03:08:35PM +0100, Jan Kara wrote:
> >   Yeah, but for the filesystem on top it doesn't really matter. Filesystems
> > simply don't expect underlying structures can disappear. Changing all
> > filesystems to deal with that would be too difficult so we have to make bdi
> > stay in memory as needed and just detach it from the device (request queue)
> > which goes away.
> 
> Wouldn't it be better to concentrate lifetime management to
> request_queue instead of inserting another severance layer between bdi
> and request_queue?
  Maybe, I didn't seriously look into what would the best solution be. I
trust Christoph to find a good solution for it :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
