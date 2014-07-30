Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaG3PFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:05:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45649 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbaG3PFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:05:08 -0400
Message-ID: <1406732699.4865.92.camel@jarvis>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
 kmem_cache_create+0x1a9/0x330()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-scsi@vger.kernel.org,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        poma <pomidorabelisima@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>
Date: Wed, 30 Jul 2014 19:04:59 +0400
In-Reply-To: <20140730145225.GA15757@lst.de>
References: <20140718132104.GK27940@esperanza>
	 <20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com>
	 <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
	 <20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com>
	 <20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis>
	 <20140729122611.GA25980@lst.de>
	 <20140730122135.GE28613@hansolo.jdub.homelinux.org>
	 <20140730145225.GA15757@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 16:52 +0200, Christoph Hellwig wrote:
> On Wed, Jul 30, 2014 at 08:21:35AM -0400, Josh Boyer wrote:
> > > Thanks, I've update the author, added a Cc to ћtable and pushed it out to
> > > the core-for-3.17 branch.
> > 
> > This fixes a bug in the 3.16 kernel.  Why wouldn't it be sent to Linus
> > for inclusion in the final release there?
> 
> I'm only collecting patches for scsi, but James remains formal maintainer, so
> I don't send anything to Linus.  Given that delays between me committing
> things, them getting picked up by James and finally making it to Linux-next I
> don't feel like another for-3.16 branch at this point is easily workable.

It's been remarkably current, I believe ... it's already up to date.
However, we only have 2 -next builds between now and the anticipated
3.16 release (unless Linus does another -rc) so there's not enough time
for a patch that isn't already in (although this one is).

> If James wants to cherry pick it and send it on at this time that might
> still work fine, but he seems fairly busy.

I'll pull it out and refactor the tree.

James




