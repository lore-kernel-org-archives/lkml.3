Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaH1Sys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:54:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39931 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696AbaH1Syq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:54:46 -0400
Date: Thu, 28 Aug 2014 19:54:58 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "tj@kernel.org" <tj@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.17-rc2 percpu-ref oops with virtblk remove
Message-ID: <20140828185458.GS22580@arm.com>
References: <20140828185046.GR22580@arm.com>
 <53FF7A3A.7060607@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FF7A3A.7060607@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 07:51:38PM +0100, Jens Axboe wrote:
> On 08/28/2014 12:50 PM, Will Deacon wrote:
> > Any ideas?
> 
> It's fixed in for-linus, which will go out soon, more stuff just kept
> coming in. Fix:
> 
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=cddd5d17642cc6881352732693c2ae6930e9ce65

Thanks Jens, at least it kept me entertained this afternoon.

Will
