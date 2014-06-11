Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbaFKObc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:31:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaFKObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:31:31 -0400
Date: Wed, 11 Jun 2014 07:31:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] scsi patch queue tree
Message-ID: <20140611143128.GA30904@infradead.org>
References: <20140519140614.GA12183@infradead.org>
 <20140611120143.GA26071@infradead.org>
 <1402496254.2523.3.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402496254.2523.3.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 07:17:34AM -0700, James Bottomley wrote:
> No, I was waiting to check if there was any reason to have them split,
> but I think we've scope today or tomorrow.
> 
> The only other outstanding thing is the fsync bug fix, which is waiting
> Jens' investigation of the block issues it may cause, but I'm inclined
> to send it anyway and fix up block later if there's a problem.

There's various fixes marked for stable from Paolos virtio_scsi update,
which he asked to be considered for 3.16, including a core one:

  [PATCH v3 4/6] scsi_error: fix invalid setting of host byte

also

  [PATCH] sd: bad return code of init_sd

seems like another candidate for 3.16.

