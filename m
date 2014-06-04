Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaFDPLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:11:51 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43845 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaFDPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:11:50 -0400
Message-ID: <538F3733.6040207@kernel.dk>
Date: Wed, 04 Jun 2014 09:11:47 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140510040023.GA13788@kernel.org> <5388912F.7010609@kernel.dk> <20140604111133.GA7826@infradead.org> <538F2A11.4060800@kernel.dk> <20140604142012.GA20056@infradead.org> <538F331F.60101@kernel.dk> <20140604145803.GA7826@infradead.org> <538F34FB.7050003@kernel.dk> <20140604150508.GA21551@infradead.org> <538F365C.8050604@kernel.dk> <20140604151020.GA13586@infradead.org>
In-Reply-To: <20140604151020.GA13586@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-04 09:10, Christoph Hellwig wrote:
> On Wed, Jun 04, 2014 at 09:08:12AM -0600, Jens Axboe wrote:
>>> The performance regression is caused by "blk-mq: avoid code
>>> duplication", but I don't really understand why yet.
>>
>> Gah, looks like this one dropped the tag idling. I bet that is why.
>
> Ah, thanks.  It's indeed exactly the same sort of slow down I bisected
> back then, this should have rung a bell instead of keeping me occupied
> for hours..

Patch is committed :-)

-- 
Jens Axboe

