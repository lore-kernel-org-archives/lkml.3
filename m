Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaIGSxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:53:40 -0400
Received: from verein.lst.de ([213.95.11.211]:42017 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaIGSxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:53:39 -0400
Date: Sun, 7 Sep 2014 20:53:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] scsi-lib: implement init_flush_rq and its pair
Message-ID: <20140907185338.GD23026@lst.de>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com> <1410079162-9872-6-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410079162-9872-6-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __scsi_init_request(struct request *rq, int numa_node)

Nitpick: Please use a sane name here, e.g. scsi_mq_alloc/free_sense_buffer.

