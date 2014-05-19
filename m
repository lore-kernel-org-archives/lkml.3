Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaESObX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:31:23 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:36966 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaESObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:31:21 -0400
Message-ID: <537A15B9.6000102@kernel.dk>
Date: Mon, 19 May 2014 08:31:21 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: time to move fs/bio.c to block/ ?
References: <20140519141309.GB21570@infradead.org> <537A11CC.5060708@kernel.dk> <20140519142519.GI18016@ZenIV.linux.org.uk>
In-Reply-To: <20140519142519.GI18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 08:25 AM, Al Viro wrote:
> On Mon, May 19, 2014 at 08:14:36AM -0600, Jens Axboe wrote:
>> On 05/19/2014 08:13 AM, Christoph Hellwig wrote:
>>> I recently saw patches to fs/bio.c that were sent to Al instead of Jens.
>>> I think having bio.c in fs/ is rather confusing, so maybe it's time to
>>> include the simple git-mv for it in the your for-next tree?
>>
>> Sure, I've been thinking that too for a while. I'll do the move.
> 
> While you are at it, could you take bio-integrity.c with it?  _That_
> has zero excuse being anywhere in fs/* - not even "filesystem code
> uses quite a few functions from that sucker" as with bio.c.
> FWIW, consider the move ACKed.

Yeah, I did include that in the move.

-- 
Jens Axboe

