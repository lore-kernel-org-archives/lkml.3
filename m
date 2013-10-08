Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3JHNqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:46:31 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40522 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3JHNq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:46:27 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tty-next tree
Date: Tue,  8 Oct 2013 15:44:15 +0200
Message-Id: <1381239855-16314-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381239855-16314-1-git-send-email-treding@nvidia.com>
References: <1381239855-16314-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the tty-next tree got a conflict in

	drivers/tty/serial/imx.c

caused by commits e2c2725 (serial: imx: Use NULL as the last argument of
add_preferred_console()) and b4e788d (Revert "serial: i.MX: evaluate
linux,stdout-path property").

The former commit only changes a parameter from 0 to NULL I assume it
doesn't solve the build breakage mentioned as reason for the revert, so
I kept the reversion.

Thierry
