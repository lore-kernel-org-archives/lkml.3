Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbaGBSgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:36:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39606 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaGBSgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:36:11 -0400
Date: Wed, 2 Jul 2014 11:36:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: Crash on WRITE SAME
Message-ID: <20140702183607.GA19117@infradead.org>
References: <alpine.LRH.2.02.1407021338550.20183@file01.intranet.prod.int.rdu2.redhat.com>
 <20140702181333.GA15792@infradead.org>
 <alpine.LRH.2.02.1407021423240.20183@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407021423240.20183@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 02:29:05PM -0400, Mikulas Patocka wrote:
> And what about protection information for commands that transfer partial 
> sectors? (for example, UMAP transfers 24 bytes). Should 
> scsi_transfer_length return 24 or 32 in this case?

As far as I understand so far PI is only defined for READ/WRITE
commands.  But I'll defer to Martin who is a much better source for
information on this topic.

