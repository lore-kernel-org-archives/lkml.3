Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaAIFA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:00:58 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:38247 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaAIFA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:00:57 -0500
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 10:30:56 +0530
Message-ID: <CAPUj1OM=Zn2nd98aXRCRUJrLknkS0o44V1BfuJhz5i19w+M5Ow@mail.gmail.com>
Subject: Arndale Timer Interrupt Question
From: Mj Embd <mj.embd@gmail.com>
To: linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am a bit confused on the interrupt number for CNTVIRQ..CNTHPIRQ. Can
you please help here.

As per the exynos5 public manual
What is the difference between ￼ CPU_nCNTHPIRQ[0] and CNTHPIRQ.

While the later has an interrupt ID 26, the former is part of a group
with combined interrupt id as 33 for core 0 and 54 for core 1.

For a timer interrupt which goes to PL2, which id should be used 26 or
33 for core 0 ?

Please clear this confusion.

Many Thanks
