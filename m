Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaLIUlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:41:12 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:51421 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbaLIUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:41:10 -0500
MIME-Version: 1.0
Date: Tue, 9 Dec 2014 18:41:09 -0200
Message-ID: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
Subject: da9052-regulator fails to probe in linux-next
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In linux-next I am no longer able to get da9052 regulator driver
probed on a imx53-qsb board:

[    0.128665] da9052-regulator da9052-regulator: invalid regulator ID specified
[    0.128786] da9052-regulator: probe of da9052-regulator failed with error -22
[    0.128957] ------------[ cut here ]------------
[    0.129010] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:31
sysfs_warn_dup+0x5c/0x7c()
[    0.129043] sysfs: cannot create duplicate filename
'/devices/platform/soc/60000000.aips/63fc8000.i2c/i2c-0/0-0048/da9052-regulator
'
.....

With kernel 3.18 it probes fine. Haven't bisected yet, but if anyone
has any ideas, please let me know.

Thanks
