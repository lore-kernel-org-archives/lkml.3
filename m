Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaIHDMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 23:12:18 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:45236 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaIHDMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 23:12:17 -0400
Message-ID: <1410145932.5157.3.camel@marge.simpson.net>
Subject: Re: 3.17-rc4 fails compile (arch/x86/pci/irq.c)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Date: Mon, 08 Sep 2014 05:12:12 +0200
In-Reply-To: <201409080225.s882Pntx019152@clem.clem-digital.net>
References: <201409080225.s882Pntx019152@clem.clem-digital.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adds CC)

On Sun, 2014-09-07 at 22:25 -0400, Pete Clements wrote: 
> Fyi: i386 up  -- problem introduced in rc3.
> 
>   CC      arch/x86/pci/irq.o
> arch/x86/pci/irq.c: In function 'pirq_disable_irq':
> arch/x86/pci/irq.c:1259:2: error: implicit declaration of function 'mp_should_keep_irq' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [arch/x86/pci/irq.o] Error 1
> make: *** [arch/x86/pci] Error 2
> 


