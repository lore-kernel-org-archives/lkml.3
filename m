Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3HARir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:38:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752011Ab3HARiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:38:46 -0400
Date: Thu, 1 Aug 2013 13:38:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: boris brezillon <b.brezillon@overkiz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: ohci-at91: add usb_clk for transition to common
 clk framework
In-Reply-To: <51FA9B20.3080304@cogentembedded.com>
Message-ID: <Pine.LNX.4.44L0.1308011338090.1534-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Aug 2013, Sergei Shtylyov wrote:

> > Yes.  However, a more elegant approach is to protect the relevant
> > statements with: if (defined(CONFIG_COMMON_CLK)).  This preprocessor
> 
>     You probably meant IS_ENABLED() or IS_BUIILTIN()? Or is there something I 
> don't know about gcc preprocessor?

Yes, sorry, I meant IS_ENABLED().  Boris got it right.

Alan Stern

