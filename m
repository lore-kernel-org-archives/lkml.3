Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3BOJbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:31:21 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48970
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550Ab3BOJbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:31:19 -0500
Date: Fri, 15 Feb 2013 10:29:55 +0100
From: Jens Axboe <axboe@kernel.dk>
To: OS Engineering <osengineering@stec-inc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>,
        =?utf-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>,
        Amit Kale <akale@stec-inc.com>
Subject: Re: [PATCH] EnhanceIO ssd caching software
Message-ID: <20130215092955.GY21269@kernel.dk>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15 2013, OS Engineering wrote:
> Hi Greg, Jens,
> 
> We are submitting EnhanceIO(TM) software driver for an inclusion in
> linux staging tree. Present state of this driver is beta. We have been
> posting it for a few weeks, while it was maintained at github. It is
> still being cleaned-up and is being tested by LKML members. Inclusion
> in linux staging tree will make testing and reviewing easier and help
> a future integration in Linux kernel.

>From a quick look, this looks clean enough to not warrant a stop in
staging. Why don't we just queue it up for 3.10, that will give it 3-4
months before it hits a release kernel. So plenty of time to iron out
any kinks in this. It's a driver and completely isolated at that, so I'd
have no problem doing that.

-- 
Jens Axboe

