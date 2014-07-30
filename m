Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaG3MVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:21:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbaG3MVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:21:52 -0400
Date: Wed, 30 Jul 2014 08:21:35 -0400
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-scsi@vger.kernel.org,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        poma <pomidorabelisima@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
 kmem_cache_create+0x1a9/0x330()
Message-ID: <20140730122135.GE28613@hansolo.jdub.homelinux.org>
References: <53C8FD95.5020302@gmail.com>
 <20140718132104.GK27940@esperanza>
 <20140718141747.GA23272@lst.de>
 <53C97D34.5040707@gmail.com>
 <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
 <20140719164454.GA24530@lst.de>
 <53CCDFC3.5010802@gmail.com>
 <20140726162102.GA7126@lst.de>
 <1406533762.2003.13.camel@jarvis>
 <20140729122611.GA25980@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140729122611.GA25980@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 02:26:11PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 28, 2014 at 11:49:22AM +0400, James Bottomley wrote:
> > That needs to be
> > 
> > From: James Bottomley <JBottomley@Parallels.com>
> > 
> > As well.  I do list handling on hansenpartnership.com to minimise
> > exchange wreckage on mailinglists, but I should acknowledge Parallels as
> > supporting the work I do.
> 
> Thanks, I've update the author, added a Cc to ћtable and pushed it out to
> the core-for-3.17 branch.

This fixes a bug in the 3.16 kernel.  Why wouldn't it be sent to Linus
for inclusion in the final release there?

josh
