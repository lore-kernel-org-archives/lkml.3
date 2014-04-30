Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbaD3Vm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:42:29 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63575 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759296AbaD3Vm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:42:28 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Revert "ACPI / Battery: Remove battery's proc directory" and "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
Date: Wed, 30 Apr 2014 23:58:58 +0200
Message-ID: <3471256.NMmqNu6jmx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398872369-2755-1-git-send-email-tianyu.lan@intel.com>
References: <1398872369-2755-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 30, 2014 11:39:29 PM Lan Tianyu wrote:
> The commit 1e2d9cd and 7d7ee95 remove ACPI Proc Battery
> directory and breaks some old userspace tools. This patch
> is to revert them.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Please split that into two patches so that each commit being reverted has
its own revert patch.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
