Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIABIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 21:08:37 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51012 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaIABIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 21:08:36 -0400
Date: Mon, 1 Sep 2014 10:08:33 +0900
From: Simon Horman <horms@verge.net.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: clk: shmobile: CONFIG_ARCH_R8A7794?
Message-ID: <20140901010833.GC32075@verge.net.au>
References: <1409414606.21896.105.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409414606.21896.105.camel@x220>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 06:03:26PM +0200, Paul Bolle wrote:
> Hi Hisashi,
> 
> Your commit 8de078f189da ("clk: shmobile: Add r8a7794 support") landed
> in next-20140828. It adds a single line to a Makefile. That new line
> contains a check for CONFIG_ARCH_R8A7794.
> 
> There's no Kconfig symbol ARCH_R8A7794 so this line is basically a NOP
> currently. I assume that code to add the Kconfig symbol ARCH_R8A7794 is
> queued somewhere. Is that correct?

Hi Paul,

The r8a7794 is a new Renesas SoC that we are in the process
of adding support for to mainline. A patch to add CONFIG_ARCH_R8A7794
is in the pipeline.

https://patchwork.kernel.org/patch/4812021/
