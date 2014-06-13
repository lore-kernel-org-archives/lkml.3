Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaFMRTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:19:38 -0400
Received: from verein.lst.de ([213.95.11.211]:48226 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbaFMRTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:19:35 -0400
Date: Fri, 13 Jun 2014 19:19:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
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
Message-ID: <20140613171930.GA20007@lst.de>
References: <1402607116.18202.46.camel@haakon3.risingtidesystems.com> <20140613133901.GC7371@lst.de> <1402672861.2224.11.camel@dabdike.int.hansenpartnership.com> <20140613164118.GA17282@lst.de> <1402679044.2224.38.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402679044.2224.38.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:04:04AM -0700, James Bottomley wrote:
> Yes, there is, that's where we get the conflicts.  The target tree
> updates the current SCSI drivers with target pieces.  It's hard to
> separate them out because there's usually some target tree dependency.

That's only really the case for qla2xxx, and it's not been the major
issue here (the qla2xxx target code is fairly well isolated to start with).

The issue here is that the target tree got the DIF/DIX support for
virtio_scsi, which really should have gone in through the scsi tree.
