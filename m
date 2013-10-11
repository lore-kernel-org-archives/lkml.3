Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3JKO0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:26:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39215 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3JKO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:26:42 -0400
Message-ID: <52580A65.2050401@kernel.dk>
Date: Fri, 11 Oct 2013 08:25:41 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: cache rq->q
References: <20131011041105.GA1692@kernel.org>
In-Reply-To: <20131011041105.GA1692@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 10:11 PM, Shaohua Li wrote:
> 
> If a tag is freed, the request might be used very soon. There is a short window
> rq->q is null, so cache it.

Thanks, good catch! Applied.

-- 
Jens Axboe

