Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaLYS7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 13:59:36 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33735 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaLYS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 13:59:33 -0500
MIME-Version: 1.0
X-Originating-IP: [88.196.196.206]
Date: Thu, 25 Dec 2014 20:59:33 +0200
Message-ID: <CAF75Aw2o3PH9pLet5RHWZoGKEBF0jgzJWffUC8-UT-gVbVi3+w@mail.gmail.com>
Subject: blk: INFO: possible irq lock inversion dependency detected
From: Indrek Ardel <indrek@ardel.eu>
To: linux-kernel@vger.kernel.org
Cc: Indrek Ardel <indrek@ardel.eu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zyxel NSA-220 (orion5x) reports such message during poweroff/reboot
(repro: boot, log in, poweroff). Detailed output can be found at
http://pastebin.com/raw.php?i=NUNYBLWM

Bisect showed that this started appearing since
4830959318d14bd8856437ad5beea6016ef8c484 was applied.

Kernel configs:
3.12.4...3.12.5 http://pastebin.com/raw.php?i=ZRJDYwpY
3.19-rc1 http://pastebin.com/raw.php?i=30wQ9eMv

That's all I have thus far.

Regards,
Indrek
