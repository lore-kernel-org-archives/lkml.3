Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaAUWag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:30:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:33640 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaAUWae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:30:34 -0500
Message-ID: <52DEF516.3080103@windriver.com>
Date: Tue, 21 Jan 2014 17:30:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 60/73] drivers/bluetooth: delete non-required instances
 of include <linux/init.h>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-61-git-send-email-paul.gortmaker@windriver.com> <8861C0F9-FF68-47B8-B9EB-E52BF6A72A6F@holtmann.org>
In-Reply-To: <8861C0F9-FF68-47B8-B9EB-E52BF6A72A6F@holtmann.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-21 04:55 PM, Marcel Holtmann wrote:
> Hi Paul,
> 
>> None of these files are actually using any __init type directives
>> and hence don't need to include <linux/init.h>.  Most are just a
>> left over from __devinit and __cpuinit removal, or simply due to
>> code getting copied from one driver to the next.
>>
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> Cc: Gustavo Padovan <gustavo@padovan.org>
>> Cc: Johan Hedberg <johan.hedberg@gmail.com>
>> Cc: linux-bluetooth@vger.kernel.org
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>> drivers/bluetooth/ath3k.c       | 1 -
>> drivers/bluetooth/bcm203x.c     | 1 -
>> drivers/bluetooth/bfusb.c       | 1 -
>> drivers/bluetooth/bluecard_cs.c | 1 -
>> drivers/bluetooth/bpa10x.c      | 1 -
>> drivers/bluetooth/bt3c_cs.c     | 1 -
>> drivers/bluetooth/btuart_cs.c   | 1 -
>> drivers/bluetooth/dtl1_cs.c     | 1 -
>> 8 files changed, 8 deletions(-)
> 
> I can take this single patch via bluetooth-next tree or if Linus for example wants to take the whole series, then that is fine with me as well.
> 
> Acked-by: Marcel Holtmann <marcel@holtmann.org>

Given that the merge window is open, and maintainers are likely to
have finalized their content, I might as well just keep it in this
series.  I've added your ack though -- thanks.

Paul.
--

> 
> Regards
> 
> Marcel
> 
