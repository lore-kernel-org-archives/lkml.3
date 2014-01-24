Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaAXL73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:59:29 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40054 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAXL71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:59:27 -0500
Message-ID: <1390564761.25470.4.camel@maxim-aspire-5720>
Subject: Re: [PATCH v2] memstick: rtsx: fix ms card data transfer bug
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: micky_ching@realsil.com.cn
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, gregkh@linuxfoundation.org, oakad@yahoo.com,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Date: Fri, 24 Jan 2014 13:59:21 +0200
In-Reply-To: <1384941293-16520-1-git-send-email-micky_ching@realsil.com.cn>
References: <1384941293-16520-1-git-send-email-micky_ching@realsil.com.cn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 17:54 +0800, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> This patch is used to add support for ms card. The main difference
> between ms card and mspro card is long data transfer mode. mspro card
> can use auto mode DMA for long data transfer, but ms can not use this
> mode, it should use normal mode DMA.
> 
> The memstick core add support for ms card, but the original driver will
> make ms card fail at initialize, because it use auto mode DMA. This
> patch can make ms card work properly.
Due to unexpected turn of events I bought an laptop with this card
reader.

So as soon as I have some time, I will too test this code
Really big thanks for writing this driver!

Best regards,
       Maxim Levitsky 

