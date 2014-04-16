Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaDPQvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:51:15 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35731 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaDPQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:51:13 -0400
Message-ID: <534EB507.5030503@kernel.dk>
Date: Wed, 16 Apr 2014 10:51:19 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/8] blk-mq: add blk_mq_delay_queue
References: <1397634299-7466-1-git-send-email-hch@lst.de> <1397634299-7466-5-git-send-email-hch@lst.de>
In-Reply-To: <1397634299-7466-5-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 01:44 AM, Christoph Hellwig wrote:
> Add a blk-mq equivalent to blk_delay_queue so that the scsi layer can ask
> to be kicked again after a delay.

Applied with the preempts bits from the delayed work handler removed.

-- 
Jens Axboe

