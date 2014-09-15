Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaION3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaION3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:29:38 -0400
Message-ID: <5416E9A3.20408@redhat.com>
Date: Mon, 15 Sep 2014 15:29:07 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org,
        jbottomley@parallels.com, dan.carpenter@oracle.com,
        agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] arcmsr: simplify of updating doneq_index and postq_index
References: <1410779133.4774.27.camel@Centos6.3-64>
In-Reply-To: <1410779133.4774.27.camel@Centos6.3-64>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 01:05 PM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>
> This patch is to modify previous patch 16/17 and it is relative to
> http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr
>
> change since v4:
> 1. add spin_lock in arcmsr_done4abort_postqueue for protect doneq_index.
> 2. fix spinlock area in arcmsr_hbaD_polling_ccbdone.

You might have kept the previous change log here too,
it's probably better when merged with the 16/17.

I have no more concerns, so

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

