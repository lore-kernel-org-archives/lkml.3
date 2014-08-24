Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaHXQmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 12:42:05 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:57490 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaHXQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 12:42:03 -0400
Message-ID: <53FA15D5.1030206@dev.mellanox.co.il>
Date: Sun, 24 Aug 2014 19:41:57 +0300
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-fsdevel@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>
Subject: Re: Performance degradation in IO writes vs. reads (was scsi-mq V2)
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org> <53C39F36.9010003@dev.mellanox.co.il> <53F5E6C9.1020207@dev.mellanox.co.il> <20140821130315.GB1567@infradead.org> <53F5FBF8.9040700@dev.mellanox.co.il>
In-Reply-To: <53F5FBF8.9040700@dev.mellanox.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2014 5:02 PM, Sagi Grimberg wrote:
> On 8/21/2014 4:03 PM, Christoph Hellwig wrote:
>> On Thu, Aug 21, 2014 at 03:32:09PM +0300, Sagi Grimberg wrote:
>>> So I just got back to checking this issue of *extremely low* IO write
>>> performance I got in 3.16-rc2.
>>
>> Please test with 3.16 final.  There once issue each in aio and dio
>> that caused bad I/O performance regression that were only fixed last
>> minute in the 3.16 cycle.
>>
>
> I'll do that now.
>

Indeed this issue is resolved in 3.16. Sorry for the false alarm...
Thanks Christoph.

Sagi.
