Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3KGP0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:26:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56859 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KGP0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:26:23 -0500
Message-ID: <527BB119.5070104@kernel.dk>
Date: Thu, 07 Nov 2013 08:26:17 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block/s390: Fixes for "Convert bio_for_each_segment()
 to bvec_iter"
References: <20131106214452.GA10871@kmo>
In-Reply-To: <20131106214452.GA10871@kmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 02:44 PM, Kent Overstreet wrote:
> 5d1f127c3e0c57d64ce75ee04a0db2b40a3e21df was incomplete - this just converts
> s390's drivers.

Applied, but you missed a piece in dcssblk that I updated as well.

-- 
Jens Axboe

