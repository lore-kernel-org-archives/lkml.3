Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaGSQpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 12:45:01 -0400
Received: from verein.lst.de ([213.95.11.211]:51841 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbaGSQpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 12:45:00 -0400
Date: Sat, 19 Jul 2014 18:44:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: poma <pomidorabelisima@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Message-ID: <20140719164454.GA24530@lst.de>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com> <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com> <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 01:07:26PM -0700, James Bottomley wrote:
> > Is this what you thought?
> 
> No, he means this, if you want to try it.

Yes, that's what I mean.
