Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3KARAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:00:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55506 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3KARAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:00:50 -0400
Message-ID: <5273DE35.2070707@kernel.dk>
Date: Fri, 01 Nov 2013 11:00:37 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Asias He <asias@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_blk: blk-mq support
References: <20131025130459.730903511@bombadil.infradead.org> <20131025130735.637242058@bombadil.infradead.org> <87ob6aglgl.fsf@rustcorp.com.au> <20131028085206.GB31270@infradead.org> <527029C9.2030102@kernel.dk> <20131030085124.GA30084@hj.localdomain> <20131101164548.GA28640@infradead.org>
In-Reply-To: <20131101164548.GA28640@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 10:45 AM, Christoph Hellwig wrote:
> Updated version to address Asias' comments and rebased ontop of
> block/for-next with the immutable bio changes:

Thanks, I updated the blk-mq/drivers branch to have the for-3.13/core
immutable changes and replaced the existing virtio-blk patch.

-- 
Jens Axboe

