Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbbAVQgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:36:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45000 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752061AbbAVQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:36:07 -0500
Date: Thu, 22 Jan 2015 17:36:05 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/17] ARM: at91: merge SOC_AT91SAM9xxx
Message-ID: <20150122163605.GC19922@piout.net>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421359100-8930-11-git-send-email-alexandre.belloni@free-electrons.com>
 <54C0CF5D.8020902@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54C0CF5D.8020902@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/2015 at 11:22:21 +0100, Nicolas Ferre wrote :
> Le 15/01/2015 22:58, Alexandre Belloni a écrit :
> > Only use SOC_AT91SAM9 for all the at91sam9 SoCs.
> > 
> > It enables HAVE_AT91_SMD and HAVE_AT91_UTMI for all the sam9 SoCs but this only
> > represents 96 bytes of uncompressed kernel code.
> 
> After this patch that removes all the CONFIG_SOC_AT91SAM9xxxx options
> excepted CONFIG_SOC_AT91SAM9, I still see a lot of them remaining in the
> source tree.
> 
> So, this patch is not complete in my opinion. Even if you remove these
> options later on, why not suppress them here?
> 

They went through other branches (you were in copy).


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
