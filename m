Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3JAGSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:18:34 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34060 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3JAGSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:18:32 -0400
MIME-Version: 1.0
In-Reply-To: <20131001.020134.756782177490714135.davem@davemloft.net>
References: <1380281068-13269-1-git-send-email-ricardo.ribalda@gmail.com>
 <20130930.212153.531876068589922786.davem@davemloft.net> <CAPybu_0OrwTo7CkuauRpu_ohQRY80U6BJDXQ6=KC0caOFiFCQA@mail.gmail.com>
 <20131001.020134.756782177490714135.davem@davemloft.net>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 1 Oct 2013 08:18:12 +0200
Message-ID: <CAPybu_1s2m7RzTuj7J-_ddz8C56RDa53Vwid2wdTc4dkM6s3cQ@mail.gmail.com>
Subject: Re: [PATCH] ll_temac: Reset dma descriptors on ndo_open
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, jg1.han@samsung.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, wfp5p@virginia.edu,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just send a v2 of the patch

http://patchwork.ozlabs.org/patch/279339/

Thanks!

On Tue, Oct 1, 2013 at 8:01 AM, David Miller <davem@davemloft.net> wrote:
> From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> Date: Tue, 1 Oct 2013 07:46:31 +0200
>
>> What if I move
>>        lp->tx_bd_ci = 0;
>>        lp->tx_bd_next = 0;
>>        lp->tx_bd_tail = 0;
>>        lp->rx_bd_ci = 0;
>>
>> to temac_dma_bd_init? Will this be more correct?
>
> Yes, that would be a lot better.



-- 
Ricardo Ribalda
