Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaLBBKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:10:39 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51368 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaLBBKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:10:35 -0500
From: Kevin Hilman <khilman@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, linux-sh@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: Re: [PATCH] PM / Kconfig: Do not select PM directly from Kconfig files
References: <4088467.A4Xd3YfMSv@vostro.rjw.lan>
Date: Mon, 01 Dec 2014 17:10:32 -0800
In-Reply-To: <4088467.A4Xd3YfMSv@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Sat, 29 Nov 2014 02:03:48 +0100")
Message-ID: <7h388y501j.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@rjwysocki.net> writes:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> It is not valid to select CONFIG_PM directly without selecting
> CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME too, because that breaks
> dependencies (ia64 does that) and it is not necessary to select
> CONFIG_PM directly if CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME is
> set, because it will be set automatically then (sh does that).
>
> Fix those mistakes.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Kevin Hilman <khilman@linaro.org>
