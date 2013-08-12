Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3HLMWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3HLMWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:22:45 -0400
Date: Mon, 12 Aug 2013 13:21:50 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130812122150.GA28184@agk-dp.fab.redhat.com>
Mail-Followup-To: Philippe De Muyter <phdm@macqel.be>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be> <1367270313-18871-3-git-send-email-phdm@macqel.be> <20130520163927.8e4c2fe753b60a02c368ceb5@linux-foundation.org> <20130521072754.GB19266@frolo.macqel> <20130524100452.GA15570@infradead.org> <20130524105852.GA26617@frolo.macqel> <20130812115234.GA7709@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812115234.GA7709@infradead.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 04:52:34AM -0700, Christoph Hellwig wrote:
> lvm is mostly about the Linux specific formats.  If you want to create
> a separate userspace consumer for device mapper that's probably also
> fine, but if you need support for complex layours device mapper is the
> way to go, and the partitioning layer isn't getting you anywhere.
 
If you can map the AIX volume manager objects onto the linux ones, you
can write a 'format' module for lvm2 to handle them.

Alasdair

