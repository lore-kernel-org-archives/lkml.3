Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbaGPHxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:53:23 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37719 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbaGPHxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:53:19 -0400
Message-ID: <53C62F68.4070002@kernel.dk>
Date: Wed, 16 Jul 2014 09:53:12 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: OOPS: NULL pointer dereference: blk_throtl_drain+0x28/0x110
References: <20140715222025.GA2412@hp-peter.rsr.lip6.fr>
In-Reply-To: <20140715222025.GA2412@hp-peter.rsr.lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-16 00:20, Peter Senna Tschudin wrote:
> OOPS on 3.16.0-rc5-next-20140715

I forgot to pull an extra patch into for-3.17/core (and hence for-next), 
should work now. Or apply this one separately:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=2a1b4cf2331d92bc009bf94fa02a24604cdaf24c


-- 
Jens Axboe

