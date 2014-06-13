Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaFMQl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:41:26 -0400
Received: from verein.lst.de ([213.95.11.211]:48132 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbaFMQlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:41:24 -0400
Date: Fri, 13 Jun 2014 18:41:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quinn Tran <quinn.tran@qlogic.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [GIT PULL] target updates for v3.16-rc1
Message-ID: <20140613164118.GA17282@lst.de>
References: <1402607116.18202.46.camel@haakon3.risingtidesystems.com> <20140613133901.GC7371@lst.de> <1402672861.2224.11.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402672861.2224.11.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 08:21:01AM -0700, James Bottomley wrote:
> We've been ineffectively trying to split them between target and
> initiator, since it's effectively both.  Now that we seem to have a
> workable process, why don't we just take everything (target scsi-queue
> and vhost) through the SCSI tree, that way we don't get into these
> problems in future.

virtio-scsi has nothing to do with the target.  I also think sending
target updates through the scsi tree doesn't seem very useful, as there's
is no shared code to start with.

