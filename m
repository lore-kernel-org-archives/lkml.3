Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaCSTWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaCSTWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:22:48 -0400
Date: Wed, 19 Mar 2014 15:22:44 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, axboe@fb.com
Subject: Re: block: free q->flush_rq in blk_init_allocated_queue error paths.
Message-ID: <20140319192244.GA17654@redhat.com>
References: <20140318010053.D08A2660CC5@gitolite.kernel.org>
 <20140319191221.GA10034@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319191221.GA10034@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19 2014 at  3:12pm -0400,
Dave Jones <davej@redhat.com> wrote:

> Commit 7982e90c3a ("block: fix q->flush_rq NULL pointer crash on dm-mpath flush")
> moved an allocation to blk_init_allocated_queue(), but neglected to free
> that allocation on the error paths that follow.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

Ngh.. thanks Dave!

/me hangs his head in shame...

Acked-by: Mike Snitzer <snitzer@redhat.com>

Jens, really sorry about this oversight.  I can take it on the chin and
pick this up for Linus to take this week from linux-dm.git.  Your call.
