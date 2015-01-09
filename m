Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbbAIWT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:19:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbAIWT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:19:27 -0500
Date: Fri, 9 Jan 2015 14:19:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>, wenyou.yang@atmel.com,
        ludovic.desroches@atmel.com, leilei.zhao@atmel.com,
        voice.shen@atmel.com, josh.wu@atmel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] tty/serial: at91: use correct type for
 dma_sync_*_for_cpu() and dma_sync_*_for_device()
Message-ID: <20150109221927.GA19100@kroah.com>
References: <cover.1418131298.git.cyrille.pitchen@atmel.com>
 <830a2b33ab0226405dc310c8a6d43731bf4ca8f9.1418131298.git.cyrille.pitchen@atmel.com>
 <54AFF037.1000004@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54AFF037.1000004@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 04:13:59PM +0100, Nicolas Ferre wrote:
> Le 09/12/2014 14:31, Cyrille Pitchen a écrit :
> > dma_sync_*_for_cpu() and dma_sync_*_for_device() use 'enum dma_data_direction',
> > not 'enum dma_transfer_direction'
> > 
> > Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
> 
> Sure:
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Here it's difficult to add a "stable" tag as the error was introduced by
> several different patches.

So that means it's not ok for older kernels?  That doesn't make sense...

