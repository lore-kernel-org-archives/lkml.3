Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaGUO6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:58:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaGUO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:58:22 -0400
Date: Mon, 21 Jul 2014 07:58:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: poma <pomidorabelisima@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
 kmem_cache_create+0x1a9/0x330()
Message-ID: <20140721145817.GA15433@infradead.org>
References: <53C8DF7F.5060707@gmail.com>
 <53C8FD95.5020302@gmail.com>
 <20140718132104.GK27940@esperanza>
 <20140718141747.GA23272@lst.de>
 <53C97D34.5040707@gmail.com>
 <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com>
 <20140719164454.GA24530@lst.de>
 <53CCDFC3.5010802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CCDFC3.5010802@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:39:15AM +0200, poma wrote:
> Thanks for the tip.
> Is there a patch somewhere?

James sent the patch earlier and you replied to it.

