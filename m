Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaI3Q2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:28:12 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:49944 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaI3Q2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:28:10 -0400
Date: Tue, 30 Sep 2014 17:28:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thibaut Robert <thibaut.robert@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tc: fix warning and coding style
In-Reply-To: <1412079396-26005-1-git-send-email-thibaut.robert@gmail.com>
Message-ID: <alpine.LFD.2.11.1409301720050.21156@eddie.linux-mips.org>
References: <1412079396-26005-1-git-send-email-thibaut.robert@gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Thibaut Robert wrote:

> Fix checkpatch warnings:
> WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> WARNING: Possible unnecessary 'out of memory' message
> WARNING: quoted string split across lines
> WARNING: Use #include <linux/io.h> instead of <asm/io.h>
> 
> Fix gcc warning:
> warning: format ¡%d¢ expects argument of type ¡int¢, but argument 4 has type ¡resource_size_t¢ [-Wformat=]
> 
> As resource_size_t can be 32 or 64 bits (depending on CONFIG_RESOURCES_64BIT), this patch uses "%lld" format along with a cast to u64 for printing resource_size_t values
> 
> Signed-off-by: Thibaut Robert <thibaut.robert@gmail.com>
> ---

 NAK.  These issues have already been taken care of via the LMO tree; the
original change has been archived here:

http://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=alpine.LFD.2.11.1404062030280.15266%40eddie.linux-mips.org

and is on the way to Linus's tree (IIUC; Ralf, please acknowledge).

 If you think there's anything wrong still left afterwards, except from 
the message wrapping (as I'm not going to approve any modification to go 
beyond 79 columns; this is nonsense), then please send an incremental 
change on top of that.

 Thanks for your contribution anyway.

  Maciej
