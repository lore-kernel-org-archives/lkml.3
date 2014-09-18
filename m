Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaIRFtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:49:45 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44721 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaIRFto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:49:44 -0400
Date: Wed, 17 Sep 2014 22:49:40 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Josh Wu <josh.wu@atmel.com>, David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5] mtd: nand: atmel_nand: retrieve NFC clock
Message-ID: <20140918054940.GC7362@norris-Latitude-E6410>
References: <1410564239-8411-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410564239-8411-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 01:23:59AM +0200, Alexandre Belloni wrote:
> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> Retrieve the NFC clock to make sure it is enabled. Make that optional to ensure
> compatibility with previous device trees but document it as mandatory so newer
> device trees will include it.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Josh Wu <josh.wu@atmel.com>
> ---
> Changes in v5:
>  - Added a proper commit log

Pushed to l2-mtd.git. Thanks!

Brian
