Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3FFKv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:51:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58837 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab3FFKv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:51:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH RFC v2 0/3] add cpu physically hotplug driver
Date: Thu, 06 Jun 2013 13:00:31 +0200
Message-ID: <5449620.11SBDUltzF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 06, 2013 09:40:32 AM liguang wrote:
> This patch-set try to support physically hot-plug/unplug
> a cpu automatically, that is:
> if you offline a cpu, it will automatically actually remove
> a cpu, and if you hot-plug a cpu, then it will online this
> cpu automatically.

No and no.

Why do you need this?

Rafael


> so, offline is just like eject, but eject attribute seems not
> available since recent kernel(can't figure out when), with
> this driver, if allowed, it will trigger a eject cpu process.
> and for automatically online, it was said there are objections,
> don't know the reason, so, send this patch-set boldly.
> 
> of course, this approach is for QEMU 's hotplug cpu emulation 
> only, but not limited, if someone like to explore ec space to
> implment cpu hot-plug/unplug for real platform please
> feel free to continue.
> 
> Li Guang (3)
> 	 drivers/platform/x86: add cpu physically hotplug driver
> 	 ec: add ec space notifier
> 	 cpu_physic_hotplug: register handler for ec space notifier
> 
> drivers/acpi/ec.c                         | 32 ++++++++++++++++++++++++++++++++
> drivers/platform/x86/Kconfig              |  8 ++++
> drivers/platform/x86/Makefile             |  1 +
> drivers/platform/x86/cpu_physic_hotplug.c | 90 +++++++++++++++++++++++++++++
> include/linux/acpi.h                      |  2 ++
> 5 files changed, 130 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/platform/x86/cpu_physic_hotplug.c
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
