Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3A0ARN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:17:13 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52004 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3A0ARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:17:11 -0500
X-Nat-Received: from [202.181.97.72]:49680 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1359245813.10089
To: linus.walleij@linaro.org
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201301221817.IDD95831.HVOOFMFJOLFSQt@I-love.SAKURA.ne.jp>
	<CACRpkdYRM9MDt92juV+x9w9BUnHpCSd2KCkZ5F7zwPfhn939ZQ@mail.gmail.com>
	<201301222123.CEJ65174.StJFMOQFVFHOLO@I-love.SAKURA.ne.jp>
	<201301261717.JGJ04628.OOFVHFLOFJMtSQ@I-love.SAKURA.ne.jp>
	<CACRpkdZrtBV-TJrywL4OeiuyD61qt0+txjQ51KFcmtWSc9OYXg@mail.gmail.com>
In-Reply-To: <CACRpkdZrtBV-TJrywL4OeiuyD61qt0+txjQ51KFcmtWSc9OYXg@mail.gmail.com>
Message-Id: <201301270916.GAE48437.JQSVFFOHFMtLOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 27 Jan 2013 09:16:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 26012013 #9453734, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> I'm trying to reproduce this, but how do you reconfigure the kernel to
> get PCI, SCSI and such stuff enabled?
> 
> The stock versatile_defconfig does not even have SCSI enabled...

I'm using a customized config for qemu. I've just updated the config to
http://I-love.SAKURA.ne.jp/tmp/config-3.8-rc1-arm .

Regards.
