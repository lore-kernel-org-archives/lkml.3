Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaGTE1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:27:40 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:38952 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaGTE1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:27:38 -0400
MIME-Version: 1.0
Date: Sun, 20 Jul 2014 00:27:37 -0400
Message-ID: <CAPDOMVhd-mfNfT+DbHWbzQA8sb3xpqW6a0WEuTTeCGyK8+kRNQ@mail.gmail.com>
Subject: Edma.c: Fix Mes
From: Nick Krause <xerofoify@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        robh+dt@kernel.org, nsekhar@ti.com, peter.ujfalusi@ti.com,
        joelf@ti.com, vinod.koul@intel.com,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Russell and others,
Sorry to bug you again but I have a fix questions before I clean up
the fix mes in this file.
Is edma_clean_channel needed or is edma_stop good enough?  And do  we
CCERR.BIT(16)
need to write this bit or not?
Cheers Nick
