Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbaDVVLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:11:45 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52500 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbaDVVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:09:47 -0400
Message-ID: <5356DAA7.6010107@kernel.dk>
Date: Tue, 22 Apr 2014 15:09:59 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] fs/bio.c: remove nr_segs (unused function parameter)
References: <20140422072157.66ca011625f37abda817b662@skynet.be>
In-Reply-To: <20140422072157.66ca011625f37abda817b662@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 11:21 PM, Fabian Frederick wrote:
> nr_segs is no longer used in bio_alloc_map_data since

Thanks, applied this one and your biovec_create_pool() patch for 3.16.

-- 
Jens Axboe

