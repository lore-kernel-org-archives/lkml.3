Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbbAZX4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:56:00 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbbAZXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:55:55 -0500
Message-ID: <54C6D408.5050704@nod.at>
Date: Tue, 27 Jan 2015 00:55:52 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
CC: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tom.leiming@gmail.com
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
References: <1420926734-16417-1-git-send-email-richard@nod.at> <1420926734-16417-2-git-send-email-richard@nod.at> <20150113162553.GA24351@infradead.org> <54B5A188.2000001@nod.at> <54B5A213.1090502@fb.com> <54B5A77C.9040405@nod.at> <54B5AA84.9010306@fb.com> <54B5AC10.6070102@nod.at> <54B5B6E4.4020400@fb.com> <54B62B2A.7010109@nod.at>
In-Reply-To: <54B62B2A.7010109@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.01.2015 um 09:39 schrieb Richard Weinberger:
> Am 14.01.2015 um 01:23 schrieb Jens Axboe:
>> Which is as I suspected, you'll do each segment to the length specified,
>> hence you don't need to track the returned count from blk_rq_map_sg().
> 
> Thanks a lot for the kind explanation, Jens!
> I'll add a comment the usage of blk_rq_map_sg() to avoid further confusion.
> Am I allowed to add your Reviewed-by too?

Ping?
I'd like to add a Reviewed-by to this patch.

Thanks,
//richard
