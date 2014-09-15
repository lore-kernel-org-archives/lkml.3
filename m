Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaIOLEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:04:05 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:57602 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbaIOLEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:04:04 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201409151104.s8FB413m027949@clem.clem-digital.net>
Subject: 3.17-rc5 fails compile (arch//x86/pci/irq.c)
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Mon, 15 Sep 2014 07:04:01 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi: i386 up  -- problem introduced in rc3.

  CC      arch/x86/pci/irq.o
arch/x86/pci/irq.c: In function 'pirq_disable_irq':
arch/x86/pci/irq.c:1259:2: error: implicit declaration of function 'mp_should_keep_irq' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [arch/x86/pci/irq.o] Error 1
make: *** [arch/x86/pci] Error 2

-- 
Pete Clements 
