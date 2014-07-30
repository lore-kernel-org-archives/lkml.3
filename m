Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaG3Owc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:52:32 -0400
Received: from verein.lst.de ([213.95.11.211]:47771 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbaG3Owb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:52:31 -0400
Date: Wed, 30 Jul 2014 16:52:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-scsi@vger.kernel.org,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        poma <pomidorabelisima@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Message-ID: <20140730145225.GA15757@lst.de>
References: <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com> <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com> <20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com> <20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis> <20140729122611.GA25980@lst.de> <20140730122135.GE28613@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140730122135.GE28613@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 08:21:35AM -0400, Josh Boyer wrote:
> > Thanks, I've update the author, added a Cc to ћtable and pushed it out to
> > the core-for-3.17 branch.
> 
> This fixes a bug in the 3.16 kernel.  Why wouldn't it be sent to Linus
> for inclusion in the final release there?

I'm only collecting patches for scsi, but James remains formal maintainer, so
I don't send anything to Linus.  Given that delays between me committing
things, them getting picked up by James and finally making it to Linux-next I
don't feel like another for-3.16 branch at this point is easily workable.

If James wants to cherry pick it and send it on at this time that might
still work fine, but he seems fairly busy.

