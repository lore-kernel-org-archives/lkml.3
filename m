Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaGNK15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:27:57 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51062 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaGNK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:27:49 -0400
Message-ID: <53C3B09D.8060600@kernel.dk>
Date: Mon, 14 Jul 2014 12:27:41 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: provide compat ioctl for BLKZEROOUT
References: <alpine.LRH.2.02.1407021244360.20183@file01.intranet.prod.int.rdu2.redhat.com> <yq1tx6l1jdq.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1tx6l1jdq.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-13 15:24, Martin K. Petersen wrote:
>>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
>
> Mikulas> This patch provides the compat BLKZEROOUT ioctl. The argument
> Mikulas> is a pointer to two uint64_t values, so there is no need to
> Mikulas> translate it.
>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Applied, thanks Mikulas.


-- 
Jens Axboe

