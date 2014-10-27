Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaJ0QeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:34:00 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59461 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJ0Qd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:33:58 -0400
Message-ID: <544E7411.5070208@gmail.com>
Date: Mon, 27 Oct 2014 09:34:25 -0700
From: Santosh Shilimkar <santosh.shilimkar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Santosh Shilimkar <ssantosh@kernel.org>
CC: Sandeep Nair <sandeep_n@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] soc: ti: Use list_first_entry_or_null() at appropriate
 places
References: <1414316264.4290.2.camel@phoenix>
In-Reply-To: <1414316264.4290.2.camel@phoenix>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

On 10/26/2014 02:37 AM, Axel Lin wrote:
> Use list_first_entry_or_null() for first_region() and first_queue_range().
>
> list_first_entry() expects the list is not empty, so first_region() and
> first_queue_range() never return NULL.
> Thus use list_first_entry_or_null() instead.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Thanks. I will pick the $subject and other two patches and queue
them up for next merge window.

Regards,
Santosh
