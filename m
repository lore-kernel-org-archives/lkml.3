Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbaC0Wwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 18:52:32 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7064 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaC0Wwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 18:52:31 -0400
X-IronPort-AV: E=Sophos;i="4.97,745,1389772800"; 
   d="scan'208";a="21935465"
From: Markus Mayer <markus.mayer@linaro.org>
To: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>
CC: <gregkh@linuxfoundation.org>, <s-anna@ti.com>, <tony@atomide.com>,
        <omar.ramirez@copitl.com>, <loic.pallardy@st.com>,
        <lftan.linux@gmail.com>, <slapdau@yahoo.com.au>,
        <courtney.cavin@sonymobile.com>, <rafael.j.wysocki@intel.com>,
        <robherring2@gmail.com>, <arnd@arndb.de>
Subject: Re: [PATCHv4 1/5] mailbox: rename pl320-ipc specific mailbox.h
Date: Thu, 27 Mar 2014 15:51:41 -0700
Message-ID: <1395960701-18725-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
References: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch 30058677 "ARM / highbank: add support for pl320 IPC"
> added a pl320 IPC specific header file as a generic mailbox.h.
> This file has been renamed appropriately to allow the
> introduction of the generic mailbox API framework.
>
> Acked-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
>
> ---
> drivers/cpufreq/highbank-cpufreq.c |  2 +-
>  drivers/mailbox/pl320-ipc.c        |  2 +-
>  include/linux/mailbox.h            | 17 -----------------
>  include/linux/pl320-ipc.h          | 17 +++++++++++++++++
>  4 files changed, 19 insertions(+), 19 deletions(-)
>  delete mode 100644 include/linux/mailbox.h
>  create mode 100644 include/linux/pl320-ipc.h

This does not look like GIT realized you were just renaming these files.
When I apply this patch and re-generate the patch file, it looks like this:

...
 drivers/cpufreq/highbank-cpufreq.c       |    2 +-
 drivers/mailbox/pl320-ipc.c              |    2 +-
 include/linux/{mailbox.h => pl320-ipc.h} |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename include/linux/{mailbox.h => pl320-ipc.h} (100%)
...

Regards,
-Markus
