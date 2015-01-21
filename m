Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbbAURho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:37:44 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39286 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbAURhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:37:36 -0500
Message-ID: <54BFE3DC.4050101@kernel.dk>
Date: Wed, 21 Jan 2015 10:37:32 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cfq-iosched: fix incorrect filing of rt async cfqq
References: <x494mrvu4wi.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494mrvu4wi.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 01:21 PM, Jeff Moyer wrote:
> Hi,
> 
> If you can manage to submit an async write as the first async I/O from
> the context of a process with realtime scheduling priority, then a
> cfq_queue is allocated, but filed into the wrong async_cfqq bucket.  It
> ends up in the best effort array, but actually has realtime I/O
> scheduling priority set in cfqq->ioprio.

Applied, thanks Jeff. I've added a stable tag to it as well.

-- 
Jens Axboe

