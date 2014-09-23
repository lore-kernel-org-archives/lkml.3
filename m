Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaIWF46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:56:58 -0400
Received: from verein.lst.de ([213.95.11.211]:49035 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbaIWF45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:56:57 -0400
Date: Tue, 23 Sep 2014 07:56:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Elliott, Robert (Server Storage)" <elliott@hp.com>
Subject: Re: two more fixes for block/for-linus
Message-ID: <20140923055654.GB10189@lst.de>
References: <1411394371-16254-1-git-send-email-hch@lst.de> <54202CF9.7050303@kernel.dk> <54206D0F.1010506@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54206D0F.1010506@interlog.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 02:40:15PM -0400, Douglas Gilbert wrote:
> With these patches applied (actually a resync an hour
> ago with the for-linus tree which includes them), the
> freeze-during-boot-up problem that I have been seeing
> with an old SATA boot disk (perhaps 1.5 Gbps) for
> the last two weeks, has gone away.
>
> That SATA disk is connected to the motherboard (Gigabyte
> Z97M-D3H/Z97M-D3H, BIOS F5 05/30/2014) and has a standard
> AHCI interface as far as I can tell. dmesg confirms that.

Should have thought of the weird ATA error handling earlier.  Sorry Doug!

