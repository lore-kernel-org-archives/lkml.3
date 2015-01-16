Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbbAPBzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:55:39 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:51358 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbbAPBzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:55:38 -0500
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        jon.nettleton@gmail.com, dsd@laptop.org, jfrederich@gmail.com,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH 0/2] staging: olpc_dcon: fix sparse warnings and compile errors
Date: Thu, 15 Jan 2015 23:54:58 -0200
Message-Id: <1421373300-13672-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix sparse warnings and make olpc_dcon.c build again
when CONFIG_OLPC is not set.

Murilo Opsfelder Araujo (2):
  staging: olpc_dcon: check for CONFIG_OLPC before calling
    olpc_board_at_least()
  staging: olpc_dcon: fix sparse symbol not declared warning

 drivers/staging/olpc_dcon/olpc_dcon.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--
2.1.0
