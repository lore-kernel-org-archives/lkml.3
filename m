Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab3GMSIh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:08:37 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47011 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab3GMSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:08:35 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 0/3] Misc cleanups in kconfig for symbol-search
Date: Sat, 13 Jul 2013 20:08:22 +0200
Message-Id: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

Here are a few code cleanups after Jean's review:
    [PATCH 1/3] Documentation/kconfig: more concise and straightforward
    [PATCH 2/3] kconfig: avoid multiple calls to strlen
    [PATCH 3/3] kconfig: cleanup symbol-search code

If everything is good, I'll send a pull-request to Michal a bit later
during the rc phase (in case more fixups accumulate).

Regards,
Yann E. MORIN.
