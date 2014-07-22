Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaGVEQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:16:28 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:36401 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaGVEQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:16:27 -0400
MIME-Version: 1.0
Date: Tue, 22 Jul 2014 00:16:26 -0400
Message-ID: <CAPDOMVhdK67Fc5KsamL8XKdRNy0VjKB3ub24krgwmRsnZGtQNQ@mail.gmail.com>
Subject: Fix me in netx-regs.h
From: Nick Krause <xerofoify@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Russell,
I did give thought to our previous conversations and I will still do
fix mes but am going to be more careful
with I submit them. Furthermore it seems  #define
NETX_GPIO_COUNTER_CTRL_GPIO_RE is not defined
correctly. As the maintainer what should I define it to?
Cheers Nick
