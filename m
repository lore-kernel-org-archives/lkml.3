Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaIAJou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:44:50 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37214 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaIAJot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:44:49 -0400
MIME-Version: 1.0
From: =?UTF-8?Q?Rapha=C3=ABl_Poggi?= <poggi.raph@gmail.com>
Date: Mon, 1 Sep 2014 11:44:08 +0200
X-Google-Sender-Auth: PvYzZ_TPGiX0MpVl5YGZ3Kj36p0
Message-ID: <CACqcpZCQ52p70SckWU-43ue6v-3Uekq4xC=kg=jYuc0dcyze9w@mail.gmail.com>
Subject: arm: at91: sama5d3 suspend in ram
To: nicolas.ferre@atmel.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have some trouble using the suspend in ram with the sama5d3.

When the cpu execute code from pm_slowclock.S, the cpu "crash", I mean
when I connect the JTAG, the program counter has an invalid/nonsense
value.

I have tried with the patch series from Wenyou Yang :
[PATCH 0/3] ARM: at91: add enter standby mode for ARMv7
but this doesn't change anything.

The code in pm_slowclock.S doesn't seem to have been test on the sama5d3

Is there anybody who succeeded to use the slowclock with the sama5d3 ?

I'm using the linux 3.10 from github.com/linux4sam.
