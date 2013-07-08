Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3GHUee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:34:34 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60585 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3GHUeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:34:31 -0400
Date: Mon, 8 Jul 2013 17:34:37 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: George Cherian <george.cherian@ti.com>, linux-usb@vger.kernel.org,
        balbi@ti.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 0/5] Add phy support for AM335X platform using Generic
 PHy framework
Message-ID: <20130708203435.GB2596@localhost>
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
 <51DB16A1.6010006@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51DB16A1.6010006@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 08, 2013 at 09:44:33PM +0200, Sebastian Andrzej Siewior wrote:

> We need two nodes each one with a glue layer and a musb child node. The
> instances crap in kernel has to vanish. Also that means your phy nodes
> are wrong. This is not musb with two ports but two musb instances each
> with one port.
> 

I agree completely. The current DT representation looks definitely odd,
and we should be looking at improving it.

I wonder if this is now possible, given the DT is supposed to be stable ABI.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
