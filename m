Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaI2QCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:02:21 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:39175 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaI2QCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:02:19 -0400
Message-ID: <54298287.6020806@codethink.co.uk>
Date: Mon, 29 Sep 2014 17:02:15 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH 1/2] fs: proc: use __seq_open_private()
References: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>	<1410530978-29627-2-git-send-email-rob.jones@codethink.co.uk> <20140912145456.863d25e38db6fa5dea60845d@linux-foundation.org>
In-Reply-To: <20140912145456.863d25e38db6fa5dea60845d@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/09/14 22:54, Andrew Morton wrote:
> On Fri, 12 Sep 2014 15:09:37 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:
>
>> Reduce boilerplate code by using __seq_open_private() instead of seq_open().
>
> http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
> already did this.

This duplicated only half of my submission, patch 2/2 did a similar
operation on a different file (fs/proc/task_mmu.c).

https://lkml.org/lkml/2014/9/12/347

Is that one actually going in (with Andrew's rename to include the file
name) or should I resubmit it on its own?

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
