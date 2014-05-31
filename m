Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaEaNs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 09:48:29 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:52385 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbaEaNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 09:48:27 -0400
Date: Sat, 31 May 2014 09:48:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 08/12] block, bfq: preserve a low
 latency also with NCQ-capable drives
Message-ID: <20140531134823.GB24557@mtj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-9-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401354343-5527-9-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:05:39AM +0200, Paolo Valente wrote:
> This patch addresses this issue by not disabling device idling for

This patch addresses this issue by allowing device idling for...

> weight-raised queues, even if the device supports NCQ. This allows BFQ
> to start serving a new queue, and therefore allows the drive to

This disallows BFQ to start serving a new queue, and therefore the
drive to prefetch new requests, until the idling timeout expires.

Prefetch?  Can you elaborate?

Thanks.

-- 
tejun
