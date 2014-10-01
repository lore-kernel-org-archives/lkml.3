Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaJANyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:54:37 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:61085 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaJANyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:54:36 -0400
Date: Wed, 1 Oct 2014 09:54:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: misplaced rq_complete tracepoint
Message-ID: <20141001135432.GA22294@htj.dyndns.org>
References: <1412166751-73709-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412166751-73709-1-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 02:32:31PM +0200, Hannes Reinecke wrote:
> The rq_complete tracepoint was never issued for empty requests,
> causing the resulting blktrace information to never show any
> completion for those request.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
