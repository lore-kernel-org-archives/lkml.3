Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaG2M0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:26:17 -0400
Received: from verein.lst.de ([213.95.11.211]:44863 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaG2M0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:26:15 -0400
Date: Tue, 29 Jul 2014 14:26:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, poma <pomidorabelisima@gmail.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Message-ID: <20140729122611.GA25980@lst.de>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com> <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com> <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com> <20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com> <20140726162102.GA7126@lst.de> <1406533762.2003.13.camel@jarvis>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406533762.2003.13.camel@jarvis>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:49:22AM +0400, James Bottomley wrote:
> That needs to be
> 
> From: James Bottomley <JBottomley@Parallels.com>
> 
> As well.  I do list handling on hansenpartnership.com to minimise
> exchange wreckage on mailinglists, but I should acknowledge Parallels as
> supporting the work I do.

Thanks, I've update the author, added a Cc to ћtable and pushed it out to
the core-for-3.17 branch.

