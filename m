Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaDPRNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:13:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44337 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaDPRNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:13:44 -0400
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH v4 00/21] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Wed, 16 Apr 2014 21:13:10 +0400
Message-Id: <1397668411-27162-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

We had an intensive discussion of the series in the beginning of
December 2013 [1]. The discussion resulted in 3 versions of the series
in less than 3 weeks. Then there was a decision to block this series
until Daniel Mack's DMA-engine-for-PXA series is ready.

Unfortunately Daniel neigther agrees to review my trivial temporary
solution to the DMA-in-device-tree (patch 7 of 21), nor he is active
in DMA series development. There is no progress for 3 months.

As with any big out of tree series, its support is painful. It requires
extensive merging when doing bisects, on each step.

It would great if the decision to block could be reconsidered, and we could
move forward.

Best,

Sergei Ianovich

1. http://linux-kernel.2935.n7.nabble.com/PATCH-00-11-ARM-support-for-ICP-DAS-LP-8x4x-td761919.html
