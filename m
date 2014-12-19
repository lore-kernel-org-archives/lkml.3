Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaLSBnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:43:12 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64467 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751894AbaLSBmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:42:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>
Subject: [PATCH 0/4] PM: Elimination of CONFIG_PM_RUNTIME
Date: Fri, 19 Dec 2014 02:42:57 +0100
Message-ID: <472992175.g1ArEYGFPo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the last part of the CONFIG_PM_RUNTIME elimination work.

Patches [1-3/4] deal with the new uses of CONFIG_PM_RUNTIME that have
been added since the beginning of the current merge window and the last
one removes CONFIG_PM_RUNTIME and makes CONFIG_PM be a user-selectable
option.

This is on top of the current Linus' tree with my master branch merged
on top which should be a subset of current linux-next.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
