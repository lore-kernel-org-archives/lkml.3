Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040AbaDOUQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:16:10 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48113 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaDOUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:16:08 -0400
Message-ID: <534D938E.3000503@kernel.dk>
Date: Tue, 15 Apr 2014 14:16:14 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re:
References: <blk-mq updates> <1397464212-4454-1-git-send-email-hch@lst.de>
In-Reply-To: <1397464212-4454-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 02:30 AM, Christoph Hellwig wrote:
> This is the majority of the blk-mq work still required for switching
> over SCSI.  There are a few more bits for I/O completion and requeueing
> pending, but they will need further work.

Looks OK to me, I have applied them all. Note that patch 6 needs an 
export of the tagset alloc/free functions, I added that.

-- 
Jens Axboe

