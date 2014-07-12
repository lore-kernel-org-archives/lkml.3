Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaGLFlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 01:41:44 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:40787 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaGLFln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 01:41:43 -0400
MIME-Version: 1.0
Date: Sat, 12 Jul 2014 01:41:42 -0400
Message-ID: <CAPDOMVg2-B1=PkZX05jpFUorbygfjtYt=qm-6L-aiDhYZ-T=DQ@mail.gmail.com>
Subject: FIX ME in pgtable.h
From: Nick Krause <xerofoify@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: will.deacon@arm.com, steve.capper@arm.com, christoffer.dall@linaro.org,
        lauraa@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a fix me message I am hitting with cscope on line 317 of this
file about  #define kern_addr_valid(addr)   (1) not being correct.
I am wondering what value this should be set to. Thanks for the advice
so I can remove this fix me from the kernel.
Cheers Nick
