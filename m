Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab3HSIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:25:29 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:35876 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3HSIZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAMc2ieqbpwNLyY3RTKY7ZJNs2f5q9i2JRrrQSyswS1y+vff3Bg@mail.gmail.com>
References: <CAMc2ieqbpwNLyY3RTKY7ZJNs2f5q9i2JRrrQSyswS1y+vff3Bg@mail.gmail.com>
From: Mercier Ivan <ivan.mercier@gmail.com>
Date: Mon, 19 Aug 2013 10:24:46 +0200
Message-ID: <CAMc2ieq_-6kyMXq0zBh1BfuTP6u9sCK5c4nR_9QzT9P2bf26jg@mail.gmail.com>
Subject: Fwd: [arch/powerpc/sysdev/fsl_lbc.c] Elbc read/write driver
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on a freescale qoriq p3041 and trying to communicate with
a device by elbc bus in gpmc mode.

I 've integrated CONFIG_FSL_LBC in Linux which provide the basics
functions I guess.

Now I'm wondering how can I do read and write operations on the bus.

Should I code .read and .write driver functions?How can I start?

How integrates my device in the device tree?



thanks a lot,

Best Regards,
