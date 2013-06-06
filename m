Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab3FFMRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:17:35 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48535 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3FFMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH 00/32] ARM: ux500: Enable clocks for Device Tree
Date: Thu,  6 Jun 2013 13:16:48 +0100
Message-Id: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patchset has been applied, we can request clocks directly
from Device Tree without using any AUXDATA device-name hacks. We also
take care to remove all of thos at the end of the set.

