Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3KAPQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:16:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53624 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3KAPQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:16:34 -0400
Message-ID: <5273C5C5.50004@kernel.dk>
Date: Fri, 01 Nov 2013 09:16:21 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: tj@kernel.org, linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Christoph Hellwig <hch@lst.de>, rdunlap@infradead.org
Subject: Re: [PATCH] block: Document immutable biovecs
References: <1383254825-25609-1-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383254825-25609-1-git-send-email-kmo@daterainc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 03:27 PM, Kent Overstreet wrote:
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>

Added, and incorporated the changes suggested by Randy.

-- 
Jens Axboe

