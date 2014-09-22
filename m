Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaIVOGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:06:54 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58937 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaIVOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:06:53 -0400
Message-ID: <54202CF9.7050303@kernel.dk>
Date: Mon, 22 Sep 2014 08:06:49 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: two more fixes for block/for-linus
References: <1411394371-16254-1-git-send-email-hch@lst.de>
In-Reply-To: <1411394371-16254-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-22 07:59, Christoph Hellwig wrote:
> Fix two regressions with the timer/blk_mq_start_request changes found
> when using scsi-mq on an ATA device.
>
> Note that given how late we are in the cycle I wonder if we really should
> push the changes in block/for-linus to Linus in this cycle.  The race
> part of the timer fixes is extremly narrow, and the reserved request
> part of it requires an out of tree driver update to trigger it, so it
> doesn't sound super criticial.

I was planning on pushing it out today, I've run a lot of testing on it 
internally last week. Ho hum, let me think about it...

-- 
Jens Axboe

