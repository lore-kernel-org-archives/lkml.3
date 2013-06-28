Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3F1Wp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:45:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54528 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab3F1Wpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:45:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 0/3] ACPI / dock: Notification rework and memory leak fix
Date: Sat, 29 Jun 2013 00:47:30 +0200
Message-ID: <1515394.L46AJCfCTt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1640211.P0jyS5muX2@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

More fixes/cleanups for the ACPI dock driver (and related), on top of the
series I sent earlier today.  [Well, that code is like the Rabbit hole in
"Alice's Adventures in Wonderland".]

[1/3] Rework the dock driver's handling of notifications (the changelog tells
      the whole story).

[2/3] After [1/3] there are no more users of the ACPI bus notifier call chain,
      so drop it.

[3/3] dock_add() leaks memory on errors (although only theoretically, because
      it is very unlikely to fail), so fix that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
