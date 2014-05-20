Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaETA2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:28:34 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:52607 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaETA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:28:32 -0400
MIME-Version: 1.0
In-Reply-To: <537A11CC.5060708@kernel.dk>
References: <20140519141309.GB21570@infradead.org>
	<537A11CC.5060708@kernel.dk>
Date: Tue, 20 May 2014 08:28:31 +0800
Message-ID: <CACVXFVNP=krc7juPwSpSSFwvsu4aifST5OUfpc4V7QE4nmm_2A@mail.gmail.com>
Subject: Re: time to move fs/bio.c to block/ ?
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:14 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/19/2014 08:13 AM, Christoph Hellwig wrote:
>> I recently saw patches to fs/bio.c that were sent to Al instead of Jens.
>> I think having bio.c in fs/ is rather confusing, so maybe it's time to
>> include the simple git-mv for it in the your for-next tree?
>
> Sure, I've been thinking that too for a while. I'll do the move.

mm/bounce.c is another one.


Thanks,
-- 
Ming Lei
