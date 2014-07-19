Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaGSWrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 18:47:39 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60667 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaGSWri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 18:47:38 -0400
MIME-Version: 1.0
Date: Sat, 19 Jul 2014 18:47:37 -0400
Message-ID: <CAPDOMVibN_jYoxHyaE1sRXj6garOmKvFoMXGV62B4FONTgJGMQ@mail.gmail.com>
Subject: bios32.c: Fix me in pci_fixup_it8152
From: Nick Krause <xerofoify@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: bhelgaas@google.com, wangyijing@huawei.com, thierry.reding@gmail.com,
        thomas.petazzoni@free-electrons.com, m-karicheri2@ti.com,
        yinghai@kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Russell and others,
Before I clean this fix me up I wanted to known how to define the values
as stated in the fix me in this function or if this is invalid as of the latest
kernel trees.
Cheers Nick
