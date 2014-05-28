Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaE1OIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:08:37 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63236 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaE1OIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:08:35 -0400
Message-ID: <5385EDE1.3020308@kernel.dk>
Date: Wed, 28 May 2014 08:08:33 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
 flush worker
References: <5384DB97.70606@kernel.dk> <20140527185301.GA8466@lst.de> <5384DF5E.3020304@kernel.dk> <20140527191510.GA9274@lst.de> <5384E4D4.6040101@kernel.dk> <20140527192130.GA9850@lst.de> <5384E8FA.8080201@kernel.dk> <CACVXFVM6YYW8N0wpKGchAVpLk72qJiqHwiUg4S4Yv+M+o-B=9g@mail.gmail.com> <5385494E.1070803@kernel.dk> <53854A76.1050807@kernel.dk> <20140528052241.GB21566@lst.de>
In-Reply-To: <20140528052241.GB21566@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-27 23:22, Christoph Hellwig wrote:
> On Tue, May 27, 2014 at 08:31:18PM -0600, Jens Axboe wrote:
>> Christoph, I'll just run a few tests and then queue it up in the morning.
>> Can you send a properly signed-off patch with a commit message as well? I
>> was writing one up, but I still need the signed-off-by.
>
> Attached.

Thanks, added.

-- 
Jens Axboe

