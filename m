Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaD3GuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:50:21 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:40180 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaD3GuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:50:18 -0400
From: Udo <udovdh@xs4all.nl>
Message-Id: <201404300650.s3U6oFU8030981@surfplank2.hierzo>
Date: Wed, 30 Apr 2014 08:50:15 +0200
To: linux-kernel@vger.kernel.org
Subject: r8169 Rx ERROR.
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Found these in dmesg:

[344307.090007] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342ac0ea
[344630.822919] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342ac09d
[345763.949918] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342cc16e
[347773.266930] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342cc096
[352604.878911] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342ac087
[354436.656703] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342ac40d
[354615.387915] r8169 0000:01:00.0 eth0: Rx ERROR. status = 342cc075
(and a load more of them)

What is wrong? Hardware?

This is 3.14.1...

Kind regards,
Udo
