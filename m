Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaEBRhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:37:51 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37890 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaEBRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:37:50 -0400
Message-ID: <5363D7EE.30805@kernel.dk>
Date: Fri, 02 May 2014 11:37:50 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] block/blk-iopoll.c: use iop instead of iopoll
References: <20140502182145.81faf8aba278b9da524d3ec6@skynet.be>
In-Reply-To: <20140502182145.81faf8aba278b9da524d3ec6@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 10:21 AM, Fabian Frederick wrote:
> All blk_iopoll functions use iop for parent iopoll structure except
> blk_iopoll_complete.This also fixes one kernel-doc warning.

Applied, thanks.

-- 
Jens Axboe

