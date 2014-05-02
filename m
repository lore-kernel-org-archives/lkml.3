Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaEBRiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:38:18 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47779 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaEBRiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:38:17 -0400
Message-ID: <5363D809.4020900@kernel.dk>
Date: Fri, 02 May 2014 11:38:17 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] block/blk-throttle.c: fix return of 0/1 with return
 type bool
References: <20140502182817.acc69a0ac05575c25311d2c6@skynet.be>
In-Reply-To: <20140502182817.acc69a0ac05575c25311d2c6@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 10:28 AM, Fabian Frederick wrote:
> Fix 4 coccinelle warnings.

Applied, thanks.

-- 
Jens Axboe

